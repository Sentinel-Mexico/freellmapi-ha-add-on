#!/usr/bin/with-contenv bashio
# ==============================================================================
# OpenSpeedTest Home Assistant Add-on — startup script
# ==============================================================================
set -e

# ---------- Configure nginx Ingress -------------------------------------------

INGRESS_PORT=8105
INGRESS_ENTRY=$(bashio::addon.ingress_entry)

bashio::log.info "Ingress entry: ${INGRESS_ENTRY}"

sed -i "s|%%SPEEDTEST_PORT%%|3000|g" /etc/nginx/http.d/ingress.conf
sed -i "s|%%INGRESS_PORT%%|${INGRESS_PORT}|g" /etc/nginx/http.d/ingress.conf

# ---------- Graceful shutdown handler -----------------------------------------

shutdown() {
    bashio::log.info "Shutting down OpenSpeedTest..."
    kill "${NGINX_PID}" 2>/dev/null || true
    wait "${NGINX_PID}" 2>/dev/null || true
    bashio::log.info "Shutdown complete."
    exit 0
}

trap shutdown SIGTERM SIGINT

# ---------- Start nginx -------------------------------------------------------

bashio::log.info "Starting OpenSpeedTest..."
bashio::log.info "  Web interface    : http://0.0.0.0:3000"
bashio::log.info ""
bashio::log.info "==================================================================="
bashio::log.info "  Access OpenSpeedTest:"
bashio::log.info "    From HA sidebar : click SpeedTest in the sidebar"
bashio::log.info "    Direct access   : http://<HA_IP>:3000"
bashio::log.info "==================================================================="
bashio::log.info ""

nginx -g "daemon off;" &
NGINX_PID=$!

bashio::log.info "OpenSpeedTest is running (PID ${NGINX_PID})."

wait "${NGINX_PID}"
