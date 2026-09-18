#!/usr/bin/with-contenv bashio
# ==============================================================================
# Syncthing Home Assistant Add-on — startup script
# ==============================================================================
set -e

# ---------- Read add-on options via bashio -----------------------------------

LOG_LEVEL=$(bashio::config 'log_level')
GUI_USER=$(bashio::config 'gui_user')
GUI_PASSWORD=$(bashio::config 'gui_password')

# ---------- Map log level to Syncthing verbosity -----------------------------

case "${LOG_LEVEL}" in
    debug) ST_LOG_FLAGS="--verbose" ;;
    warn|error) ST_LOG_FLAGS="" ;;
    *) ST_LOG_FLAGS="" ;;
esac

# ---------- Persistent data directory -----------------------------------------

DATA_DIR="/data/syncthing"
CONFIG_DIR="${DATA_DIR}/config"
SYNC_DIR="${DATA_DIR}/sync"
mkdir -p "${CONFIG_DIR}" "${SYNC_DIR}"

# ---------- First-run: generate config if missing ----------------------------

if [ ! -f "${CONFIG_DIR}/config.xml" ]; then
    bashio::log.info "Generating initial Syncthing configuration..."
    /usr/local/bin/syncthing generate --config="${CONFIG_DIR}" --skip-port-probing
fi

# ---------- Patch config.xml for GUI address and auth -----------------------

CONFIG_FILE="${CONFIG_DIR}/config.xml"

sed -i 's|<address>127\.0\.0\.1:8384</address>|<address>0.0.0.0:8384</address>|g' "${CONFIG_FILE}"

if [ -n "${GUI_USER}" ] && [ -n "${GUI_PASSWORD}" ]; then
    HASHED_PASS=$(/usr/local/bin/syncthing generate --config=/tmp/st-tmp --skip-port-probing 2>/dev/null; \
                  /usr/local/bin/syncthing cli --config=/tmp/st-tmp --data=/tmp/st-tmp-data misc hash-password "${GUI_PASSWORD}" 2>/dev/null | grep -oP '\$2[aby]\$\S+' || echo "")
    rm -rf /tmp/st-tmp /tmp/st-tmp-data

    if [ -n "${HASHED_PASS}" ]; then
        sed -i "s|<user>[^<]*</user>|<user>${GUI_USER}</user>|g" "${CONFIG_FILE}"
        sed -i "s|<password>[^<]*</password>|<password>${HASHED_PASS}</password>|g" "${CONFIG_FILE}"
        bashio::log.info "GUI authentication configured for user: ${GUI_USER}"
    else
        bashio::log.warning "Could not hash GUI password — authentication not set."
    fi
else
    bashio::log.info "GUI authentication not configured (no user/password set)."
fi

# ---------- Configure nginx Ingress -------------------------------------------

INGRESS_PORT=8104
INGRESS_ENTRY=$(bashio::addon.ingress_entry)

bashio::log.info "Ingress entry: ${INGRESS_ENTRY}"

sed -i "s|%%SYNCTHING_PORT%%|8384|g" /etc/nginx/http.d/ingress.conf
sed -i "s|%%INGRESS_PORT%%|${INGRESS_PORT}|g" /etc/nginx/http.d/ingress.conf

# ---------- Start nginx (background) -----------------------------------------

bashio::log.info "Starting nginx for Ingress proxy..."
nginx -g "daemon off;" &
NGINX_PID=$!

# ---------- Graceful shutdown handler -----------------------------------------

shutdown() {
    bashio::log.info "Shutting down Syncthing..."
    kill "${ST_PID}" 2>/dev/null || true
    kill "${NGINX_PID}" 2>/dev/null || true
    wait "${ST_PID}" 2>/dev/null || true
    wait "${NGINX_PID}" 2>/dev/null || true
    bashio::log.info "Shutdown complete."
    exit 0
}

trap shutdown SIGTERM SIGINT

# ---------- Start Syncthing --------------------------------------------------

bashio::log.info "Starting Syncthing..."
bashio::log.info "  Config directory : ${CONFIG_DIR}"
bashio::log.info "  Sync directory   : ${SYNC_DIR}"
bashio::log.info "  Web interface    : http://0.0.0.0:8384"

export STGUIADDRESS="0.0.0.0:8384"
export STNOUPGRADE="1"
export STNODEFAULTFOLDER="1"

/usr/local/bin/syncthing serve \
    --home="${CONFIG_DIR}" \
    --no-browser \
    --no-restart \
    --no-upgrade \
    ${ST_LOG_FLAGS} &
ST_PID=$!

bashio::log.info "Syncthing is running (PID ${ST_PID})."
bashio::log.info ""
bashio::log.info "==================================================================="
bashio::log.info "  Access Syncthing:"
bashio::log.info "    From HA sidebar : click Syncthing in the sidebar"
bashio::log.info "    Direct access   : http://<HA_IP>:8384"
bashio::log.info "==================================================================="
bashio::log.info ""
bashio::log.info "  Shared folders accessible at:"
bashio::log.info "    /share      — Home Assistant shared folder"
bashio::log.info "    /media      — Home Assistant media folder"
bashio::log.info "    /backup     — Home Assistant backup folder"
bashio::log.info "==================================================================="
bashio::log.info ""

wait "${ST_PID}"
