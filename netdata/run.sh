#!/usr/bin/with-contenv bashio
# ==============================================================================
# Netdata Home Assistant Add-on — startup script
# ==============================================================================
set -e

# ---------- Read add-on options via bashio -----------------------------------

LOG_LEVEL=$(bashio::config 'log_level')

# ---------- Map log level to Netdata log level --------------------------------

case "${LOG_LEVEL}" in
    debug)   ND_LOG_LEVEL="debug" ;;
    info)    ND_LOG_LEVEL="info" ;;
    warning) ND_LOG_LEVEL="warning" ;;
    error)   ND_LOG_LEVEL="error" ;;
    *)       ND_LOG_LEVEL="info" ;;
esac

# ---------- Persistent data directories ---------------------------------------

DATA_DIR="/data/netdata"
DB_DIR="${DATA_DIR}/db"
CACHE_DIR="${DATA_DIR}/cache"
mkdir -p "${DB_DIR}" "${CACHE_DIR}" /var/run/netdata /var/log/netdata

# ---------- Build Netdata configuration ---------------------------------------

NETDATA_CONF="/etc/netdata/netdata.conf"

cat > "${NETDATA_CONF}" <<EOF
[global]
    run as user = root
    hostname = homeassistant
    dbengine multihost disk space MB = 256
    debug log = none
    access log = none
    error log = syslog

[web]
    bind to = 0.0.0.0
    default port = 19999
    allow connections from = *
    allow dashboard from = *
    allow badges from = *
    allow streaming from = *
    allow netdata.conf from = *

[db]
    mode = dbengine
    dbengine tier 0 disk space MB = 256
    storage tiers = 1

[directories]
    cache = ${CACHE_DIR}
    lib = ${DB_DIR}
    log = /var/log/netdata

[logs]
    level = ${ND_LOG_LEVEL}

[plugins]
    proc = yes
    diskspace = yes
    cgroups = yes
    tc = no
    idlejitter = yes
    apps = yes
EOF

# ---------- Configure nginx Ingress -------------------------------------------

INGRESS_PORT=8106
INGRESS_ENTRY=$(bashio::addon.ingress_entry)

bashio::log.info "Ingress entry: ${INGRESS_ENTRY}"

sed -i "s|%%NETDATA_PORT%%|19999|g" /etc/nginx/http.d/ingress.conf
sed -i "s|%%INGRESS_PORT%%|${INGRESS_PORT}|g" /etc/nginx/http.d/ingress.conf

# ---------- Start nginx (background) -----------------------------------------

bashio::log.info "Starting nginx for Ingress proxy..."
nginx -g "daemon off;" &
NGINX_PID=$!

# ---------- Graceful shutdown handler -----------------------------------------

shutdown() {
    bashio::log.info "Shutting down Netdata..."
    kill "${ND_PID}" 2>/dev/null || true
    kill "${NGINX_PID}" 2>/dev/null || true
    wait "${ND_PID}" 2>/dev/null || true
    wait "${NGINX_PID}" 2>/dev/null || true
    bashio::log.info "Shutdown complete."
    exit 0
}

trap shutdown SIGTERM SIGINT

# ---------- Start Netdata -----------------------------------------------------

bashio::log.info "Starting Netdata..."
bashio::log.info "  Log level      : ${ND_LOG_LEVEL}"
bashio::log.info "  Data directory  : ${DB_DIR}"
bashio::log.info "  Web dashboard   : http://0.0.0.0:19999"

/usr/sbin/netdata -D -c "${NETDATA_CONF}" &
ND_PID=$!

bashio::log.info "Netdata is running (PID ${ND_PID})."
bashio::log.info ""
bashio::log.info "==================================================================="
bashio::log.info "  Access Netdata:"
bashio::log.info "    From HA sidebar : click Netdata in the sidebar"
bashio::log.info "    Direct access   : http://<HA_IP>:19999"
bashio::log.info "==================================================================="
bashio::log.info ""

wait "${ND_PID}"
