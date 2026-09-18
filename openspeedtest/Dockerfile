ARG BUILD_FROM="ghcr.io/home-assistant/amd64-base:3.21"

# ---------------------------------------------------------------------------
# Stage 1 — Pull the official OpenSpeedTest image to copy web assets
# ---------------------------------------------------------------------------
FROM openspeedtest/latest AS upstream

# ---------------------------------------------------------------------------
# Stage 2 — Home Assistant runtime
# ---------------------------------------------------------------------------
FROM ${BUILD_FROM}

ARG BUILD_VERSION
ARG BUILD_ARCH

LABEL io.hass.name="OpenSpeedTest"
LABEL io.hass.description="Self-hosted network speed test"
LABEL io.hass.version="${BUILD_VERSION}"
LABEL io.hass.type="addon"

RUN apk add --no-cache \
        nginx \
        curl

RUN mkdir -p /var/www/html

COPY --from=upstream /var/www/html /var/www/html

COPY run.sh /
COPY nginx-ingress.conf /etc/nginx/http.d/ingress.conf
COPY nginx-speedtest.conf /etc/nginx/http.d/speedtest.conf

RUN rm -f /etc/nginx/http.d/default.conf
RUN chmod a+x /run.sh

HEALTHCHECK --interval=30s --timeout=5s --start-period=10s --retries=3 \
    CMD curl -sf http://127.0.0.1:3000 >/dev/null || exit 1

CMD [ "/run.sh" ]
