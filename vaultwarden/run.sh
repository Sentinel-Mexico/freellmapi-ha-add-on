#!/usr/bin/with-contenv bashio
# ==============================================================================
# Vaultwarden Home Assistant Add-on — startup script
# ==============================================================================
set -e

# ---------- Read add-on options via bashio -----------------------------------

SIGNUPS_ALLOWED=$(bashio::config 'signups_allowed')
ADMIN_TOKEN=$(bashio::config 'admin_token')
LOG_LEVEL=$(bashio::config 'log_level')
DOMAIN=$(bashio::config 'domain')

SMTP_HOST=$(bashio::config 'smtp_host')
SMTP_PORT=$(bashio::config 'smtp_port')
SMTP_SECURITY=$(bashio::config 'smtp_security')
SMTP_USERNAME=$(bashio::config 'smtp_username')
SMTP_PASSWORD=$(bashio::config 'smtp_password')
SMTP_FROM=$(bashio::config 'smtp_from')

# ---------- Persistent data directory -----------------------------------------

DATA_DIR="/data/vaultwarden"
mkdir -p "${DATA_DIR}"

# ---------- Export environment for Vaultwarden --------------------------------

export DATA_FOLDER="${DATA_DIR}"
export ROCKET_ADDRESS="0.0.0.0"
export ROCKET_PORT=8080
export WEB_VAULT_FOLDER="/opt/vaultwarden/web-vault"
export WEB_VAULT_ENABLED=true
export LOG_LEVEL="${LOG_LEVEL}"
export SIGNUPS_ALLOWED="${SIGNUPS_ALLOWED}"
export SHOW_PASSWORD_HINT=false

if [ -n "${ADMIN_TOKEN}" ]; then
    export ADMIN_TOKEN="${ADMIN_TOKEN}"
    bashio::log.info "Admin panel enabled at /admin"
else
    bashio::log.info "Admin panel disabled (no admin token set)."
fi

if [ -n "${DOMAIN}" ]; then
    export DOMAIN="${DOMAIN}"
    bashio::log.info "Domain set to: ${DOMAIN}"
fi

# ---------- SMTP configuration ------------------------------------------------

if [ -n "${SMTP_HOST}" ]; then
    export SMTP_HOST="${SMTP_HOST}"
    export SMTP_PORT="${SMTP_PORT}"
    export SMTP_SECURITY="${SMTP_SECURITY}"
    export SMTP_FROM="${SMTP_FROM}"

    if [ -n "${SMTP_USERNAME}" ]; then
        export SMTP_USERNAME="${SMTP_USERNAME}"
        export SMTP_PASSWORD="${SMTP_PASSWORD}"
    fi

    bashio::log.info "SMTP configured via ${SMTP_HOST}:${SMTP_PORT}"
else
    bashio::log.info "SMTP not configured — email features disabled."
fi

# ---------- Configure nginx Ingress -------------------------------------------

INGRESS_PORT=8100
INGRESS_ENTRY=$(bashio::addon.ingress_entry)

bashio::log.info "Ingress entry: ${INGRESS_ENTRY}"

sed -i "s|%%ROCKET_PORT%%|8080|g" /etc/nginx/http.d/ingress.conf
sed -i "s|%%INGRESS_PORT%%|${INGRESS_PORT}|g" /etc/nginx/http.d/ingress.conf

# ---------- Start nginx (background) -----------------------------------------

bashio::log.info "Starting nginx for Ingress proxy..."
nginx -g "daemon off;" &
NGINX_PID=$!

# ---------- Graceful shutdown handler -----------------------------------------

shutdown() {
    bashio::log.info "Shutting down Vaultwarden..."
    kill "${VW_PID}" 2>/dev/null || true
    kill "${NGINX_PID}" 2>/dev/null || true
    wait "${VW_PID}" 2>/dev/null || true
    wait "${NGINX_PID}" 2>/dev/null || true
    bashio::log.info "Shutdown complete."
    exit 0
}

trap shutdown SIGTERM SIGINT

# ---------- Start Vaultwarden ------------------------------------------------

bashio::log.info "Starting Vaultwarden..."
bashio::log.info "  Data directory  : ${DATA_DIR}"
bashio::log.info "  Log level       : ${LOG_LEVEL}"
bashio::log.info "  Signups allowed : ${SIGNUPS_ALLOWED}"
bashio::log.info "  Web vault       : http://0.0.0.0:8080"

/usr/local/bin/vaultwarden &
VW_PID=$!

bashio::log.info "Vaultwarden is running (PID ${VW_PID})."
bashio::log.info ""
bashio::log.info "==================================================================="
bashio::log.info "  Access the web vault:"
bashio::log.info "    From HA sidebar : click Vaultwarden in the sidebar"
bashio::log.info "    Direct access   : http://<HA_IP>:8080"
bashio::log.info "==================================================================="
bashio::log.info ""

wait "${VW_PID}"
