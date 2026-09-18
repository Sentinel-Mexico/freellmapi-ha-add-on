#!/usr/bin/with-contenv bashio
# ==============================================================================
# AFFiNE Home Assistant Add-on — startup script
# ==============================================================================
set -e

# ---------- Read add-on options via bashio -----------------------------------

SERVER_NAME=$(bashio::config 'server_name')
LOG_LEVEL=$(bashio::config 'log_level')

MAILER_HOST=$(bashio::config 'mailer_host')
MAILER_PORT=$(bashio::config 'mailer_port')
MAILER_USER=$(bashio::config 'mailer_user')
MAILER_PASSWORD=$(bashio::config 'mailer_password')
MAILER_SENDER=$(bashio::config 'mailer_sender')

# ---------- Persistent data directory -----------------------------------------

DATA_DIR="/data/affine"
PG_DATA="${DATA_DIR}/pgdata"
STORAGE_DIR="${DATA_DIR}/storage"
CONFIG_DIR="${DATA_DIR}/config"
mkdir -p "${DATA_DIR}" "${PG_DATA}" "${STORAGE_DIR}" "${CONFIG_DIR}" \
         /run/postgresql /run/redis

# ---------- Generate private key if not present -------------------------------

PRIVATE_KEY_FILE="${CONFIG_DIR}/private.key"
if [ ! -f "${PRIVATE_KEY_FILE}" ]; then
    openssl rand -hex 32 > "${PRIVATE_KEY_FILE}"
    chmod 600 "${PRIVATE_KEY_FILE}"
    bashio::log.info "Generated new AFFiNE private key and saved to persistent storage."
else
    bashio::log.info "Loaded existing AFFiNE private key from persistent storage."
fi

# ---------- Build config.json -------------------------------------------------

INGRESS_ENTRY=$(bashio::addon.ingress_entry)
EXTERNAL_URL="http://localhost:3010"

CONFIG_JSON="${CONFIG_DIR}/config.json"

CONFIG_OBJ=$(jq -n \
    --arg name "${SERVER_NAME}" \
    --arg extUrl "${EXTERNAL_URL}" \
    '{
        server: {
            name: $name,
            externalUrl: $extUrl
        },
        copilot: {
            enabled: true,
            byok: { enabled: true }
        }
    }')

if [ -n "${MAILER_HOST}" ]; then
    CONFIG_OBJ=$(echo "${CONFIG_OBJ}" | jq \
        --arg host "${MAILER_HOST}" \
        --argjson port "${MAILER_PORT}" \
        --arg user "${MAILER_USER}" \
        --arg pass "${MAILER_PASSWORD}" \
        --arg sender "${MAILER_SENDER}" \
        '.mailer.SMTP = {
            host: $host,
            port: $port,
            username: $user,
            password: $pass,
            sender: $sender
        }')
    bashio::log.info "SMTP configured via ${MAILER_HOST}:${MAILER_PORT}"
else
    bashio::log.info "SMTP not configured — email features disabled."
fi

echo "${CONFIG_OBJ}" > "${CONFIG_JSON}"

# ---------- Initialize PostgreSQL if needed -----------------------------------

chown -R postgres:postgres "${PG_DATA}" /run/postgresql 2>/dev/null || true

if [ ! -f "${PG_DATA}/PG_VERSION" ]; then
    bashio::log.info "Initializing PostgreSQL database..."
    su postgres -c "initdb -D '${PG_DATA}' --auth=trust --no-locale --encoding=UTF8"
fi

bashio::log.info "Starting PostgreSQL..."
su postgres -c "pg_ctl -D '${PG_DATA}' -l '${DATA_DIR}/postgresql.log' -o '-h 127.0.0.1 -p 5432' start"

sleep 2

su postgres -c "psql -h 127.0.0.1 -p 5432 -tc \"SELECT 1 FROM pg_database WHERE datname='affine'\"" | grep -q 1 || \
    su postgres -c "createdb -h 127.0.0.1 -p 5432 affine"

bashio::log.info "PostgreSQL is ready."

# ---------- Start Redis -------------------------------------------------------

bashio::log.info "Starting Redis..."
redis-server --daemonize yes --bind 127.0.0.1 --port 6379 \
    --dir "${DATA_DIR}" --loglevel warning
bashio::log.info "Redis is ready."

# ---------- Export environment for AFFiNE ------------------------------------

export DATABASE_URL="postgresql://postgres@127.0.0.1:5432/affine"
export REDIS_SERVER_HOST="127.0.0.1"
export REDIS_SERVER_PORT="6379"
export AFFINE_SERVER_PORT="3010"
export AFFINE_INDEXER_ENABLED="false"
export AFFINE_PRIVATE_KEY=$(cat "${PRIVATE_KEY_FILE}")
export NODE_ENV="production"

# ---------- Run database migrations -------------------------------------------

bashio::log.info "Running AFFiNE pre-deploy migrations..."
cd /opt/affine
node ./scripts/self-host-predeploy.js 2>&1 || bashio::log.warning "Pre-deploy returned non-zero (may be first run)."

# ---------- Configure nginx Ingress -------------------------------------------

INGRESS_PORT=8103

bashio::log.info "Ingress entry: ${INGRESS_ENTRY}"

sed -i "s|%%AFFINE_PORT%%|3010|g" /etc/nginx/http.d/ingress.conf
sed -i "s|%%INGRESS_PORT%%|${INGRESS_PORT}|g" /etc/nginx/http.d/ingress.conf

# ---------- Start nginx (background) -----------------------------------------

bashio::log.info "Starting nginx for Ingress proxy..."
nginx -g "daemon off;" &
NGINX_PID=$!

# ---------- Graceful shutdown handler -----------------------------------------

shutdown() {
    bashio::log.info "Shutting down AFFiNE..."
    kill "${AFFINE_PID}" 2>/dev/null || true
    kill "${NGINX_PID}" 2>/dev/null || true
    wait "${AFFINE_PID}" 2>/dev/null || true
    wait "${NGINX_PID}" 2>/dev/null || true
    redis-cli -h 127.0.0.1 -p 6379 shutdown nosave 2>/dev/null || true
    su postgres -c "pg_ctl -D '${PG_DATA}' stop -m fast" 2>/dev/null || true
    bashio::log.info "Shutdown complete."
    exit 0
}

trap shutdown SIGTERM SIGINT

# ---------- Symlink config and storage into AFFiNE home ----------------------

AFFINE_HOME="/root/.affine"
mkdir -p "${AFFINE_HOME}"
ln -sfn "${STORAGE_DIR}" "${AFFINE_HOME}/storage"
ln -sfn "${CONFIG_DIR}" "${AFFINE_HOME}/config"

# ---------- Start AFFiNE -----------------------------------------------------

bashio::log.info "Starting AFFiNE..."
bashio::log.info "  Server name      : ${SERVER_NAME}"
bashio::log.info "  Data directory   : ${DATA_DIR}"
bashio::log.info "  Web interface    : http://0.0.0.0:3010"

cd /opt/affine
node ./dist/index.js &
AFFINE_PID=$!

bashio::log.info "AFFiNE is running (PID ${AFFINE_PID})."
bashio::log.info ""
bashio::log.info "==================================================================="
bashio::log.info "  Access AFFiNE:"
bashio::log.info "    From HA sidebar : click AFFiNE in the sidebar"
bashio::log.info "    Direct access   : http://<HA_IP>:3010"
bashio::log.info "==================================================================="
bashio::log.info ""

wait "${AFFINE_PID}"
