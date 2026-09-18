#!/usr/bin/with-contenv bashio
# ==============================================================================
# Linkwarden Home Assistant Add-on — startup script
# ==============================================================================
set -e

# ---------- Read add-on options via bashio -----------------------------------

NEXTAUTH_SECRET=$(bashio::config 'nextauth_secret')
REGISTRATION_ENABLED=$(bashio::config 'registration_enabled')
LOG_LEVEL=$(bashio::config 'log_level')

SMTP_HOST=$(bashio::config 'smtp_host')
SMTP_PORT=$(bashio::config 'smtp_port')
SMTP_USERNAME=$(bashio::config 'smtp_username')
SMTP_PASSWORD=$(bashio::config 'smtp_password')
SMTP_FROM_EMAIL=$(bashio::config 'smtp_from_email')

# ---------- Persistent data directory -----------------------------------------

DATA_DIR="/data/linkwarden"
PG_DATA="${DATA_DIR}/pgdata"
ARCHIVES_DIR="${DATA_DIR}/archives"
mkdir -p "${DATA_DIR}" "${PG_DATA}" "${ARCHIVES_DIR}" /run/postgresql

# ---------- Generate NextAuth secret if not set -------------------------------

if [ -z "${NEXTAUTH_SECRET}" ]; then
    SECRET_FILE="${DATA_DIR}/.nextauth_secret"
    if [ -f "${SECRET_FILE}" ]; then
        NEXTAUTH_SECRET=$(cat "${SECRET_FILE}")
        bashio::log.info "Loaded existing NextAuth secret from persistent storage."
    else
        NEXTAUTH_SECRET=$(openssl rand -hex 32)
        echo "${NEXTAUTH_SECRET}" > "${SECRET_FILE}"
        chmod 600 "${SECRET_FILE}"
        bashio::log.info "Generated new NextAuth secret and saved to persistent storage."
    fi
fi

# ---------- Initialize PostgreSQL if needed -----------------------------------

chown -R postgres:postgres "${PG_DATA}" /run/postgresql 2>/dev/null || true

if [ ! -f "${PG_DATA}/PG_VERSION" ]; then
    bashio::log.info "Initializing PostgreSQL database..."
    su postgres -c "initdb -D '${PG_DATA}' --auth=trust --no-locale --encoding=UTF8"
fi

bashio::log.info "Starting PostgreSQL..."
su postgres -c "pg_ctl -D '${PG_DATA}' -l '${DATA_DIR}/postgresql.log' -o '-h 127.0.0.1 -p 5432' start"

sleep 2

su postgres -c "psql -h 127.0.0.1 -p 5432 -tc \"SELECT 1 FROM pg_database WHERE datname='linkwarden'\"" | grep -q 1 || \
    su postgres -c "createdb -h 127.0.0.1 -p 5432 linkwarden"

bashio::log.info "PostgreSQL is ready."

# ---------- Export environment for Linkwarden ---------------------------------

export DATABASE_URL="postgresql://postgres@127.0.0.1:5432/linkwarden"
export NEXTAUTH_SECRET="${NEXTAUTH_SECRET}"
export NEXTAUTH_URL="http://localhost:3000"
export NEXT_PUBLIC_DISABLE_REGISTRATION="$([ "${REGISTRATION_ENABLED}" = "true" ] && echo "false" || echo "true")"
export STORAGE_FOLDER="${ARCHIVES_DIR}"
export PUPPETEER_EXECUTABLE_PATH="/usr/bin/chromium-browser"
export NODE_ENV="production"

# ---------- SMTP configuration ------------------------------------------------

if [ -n "${SMTP_HOST}" ]; then
    export NEXT_PUBLIC_EMAIL_PROVIDER="true"
    export EMAIL_SERVER="smtp://${SMTP_USERNAME}:${SMTP_PASSWORD}@${SMTP_HOST}:${SMTP_PORT}"
    export EMAIL_FROM="${SMTP_FROM_EMAIL}"
    bashio::log.info "SMTP configured via ${SMTP_HOST}:${SMTP_PORT}"
else
    bashio::log.info "SMTP not configured — email features disabled."
fi

# ---------- Run database migrations -------------------------------------------

bashio::log.info "Running database migrations..."
cd /opt/linkwarden
npx prisma migrate deploy 2>&1 || bashio::log.warning "Migration returned non-zero (may be first run)."

# ---------- Configure nginx Ingress -------------------------------------------

INGRESS_PORT=8102
INGRESS_ENTRY=$(bashio::addon.ingress_entry)

bashio::log.info "Ingress entry: ${INGRESS_ENTRY}"

sed -i "s|%%LINKWARDEN_PORT%%|3000|g" /etc/nginx/http.d/ingress.conf
sed -i "s|%%INGRESS_PORT%%|${INGRESS_PORT}|g" /etc/nginx/http.d/ingress.conf

# ---------- Start nginx (background) -----------------------------------------

bashio::log.info "Starting nginx for Ingress proxy..."
nginx -g "daemon off;" &
NGINX_PID=$!

# ---------- Graceful shutdown handler -----------------------------------------

shutdown() {
    bashio::log.info "Shutting down Linkwarden..."
    kill "${LW_PID}" 2>/dev/null || true
    kill "${NGINX_PID}" 2>/dev/null || true
    wait "${LW_PID}" 2>/dev/null || true
    wait "${NGINX_PID}" 2>/dev/null || true
    su postgres -c "pg_ctl -D '${PG_DATA}' stop -m fast" 2>/dev/null || true
    bashio::log.info "Shutdown complete."
    exit 0
}

trap shutdown SIGTERM SIGINT

# ---------- Start Linkwarden -------------------------------------------------

bashio::log.info "Starting Linkwarden..."
bashio::log.info "  Data directory   : ${DATA_DIR}"
bashio::log.info "  Archives         : ${ARCHIVES_DIR}"
bashio::log.info "  Registration     : ${REGISTRATION_ENABLED}"
bashio::log.info "  Web interface    : http://0.0.0.0:3000"

cd /opt/linkwarden
node server.js &
LW_PID=$!

bashio::log.info "Linkwarden is running (PID ${LW_PID})."
bashio::log.info ""
bashio::log.info "==================================================================="
bashio::log.info "  Access Linkwarden:"
bashio::log.info "    From HA sidebar : click Linkwarden in the sidebar"
bashio::log.info "    Direct access   : http://<HA_IP>:3000"
bashio::log.info "==================================================================="
bashio::log.info ""

wait "${LW_PID}"
