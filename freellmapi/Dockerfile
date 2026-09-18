ARG BUILD_FROM="ghcr.io/home-assistant/amd64-base:3.21"

# ---------------------------------------------------------------------------
# Stage 1 — build FreeLLMApi server + CLI
# ---------------------------------------------------------------------------
FROM node:20-alpine AS builder

RUN apk add --no-cache git python3 make g++

RUN git clone --depth 1 https://github.com/tashfeenahmed/freellmapi.git /build

# Build the server
WORKDIR /build/server
RUN npm ci --omit=dev 2>/dev/null; npm ci
RUN npm run build 2>/dev/null || true

# Ensure optional directories exist so COPY never fails
RUN mkdir -p /build/dashboard /build/web

# Build the CLI
WORKDIR /build/cli
RUN npm ci --omit=dev 2>/dev/null; npm ci
RUN npm run build 2>/dev/null || true

# ---------------------------------------------------------------------------
# Stage 2 — runtime
# ---------------------------------------------------------------------------
FROM ${BUILD_FROM}

ARG BUILD_VERSION

LABEL \
    io.hass.name="FreeLLMApi\" \
    io.hass.description="OpenAI-compatible LLM gateway — 34+ free providers\" \
    io.hass.version="${BUILD_VERSION}\" \
    io.hass.type="addon"

# Install runtime dependencies
RUN apk add --no-cache \
        nodejs \
        npm \
        nginx \
        jq \
        curl \
        openssl

# Create persistent data directory
RUN mkdir -p /data/freellmapi

# Copy built FreeLLMApi server
COPY --from=builder /build/server /opt/freellmapi/server

# Copy built FreeLLMApi CLI
COPY --from=builder /build/cli /opt/freellmapi/cli

# Copy the dashboard if it exists as a separate build
COPY --from=builder /build/dashboard /opt/freellmapi/dashboard
COPY --from=builder /build/web /opt/freellmapi/web

# Symlink CLI globally so it is accessible from the terminal
RUN ln -sf /opt/freellmapi/cli/src/index.js /usr/local/bin/freellmapi 2>/dev/null || \
    ln -sf /opt/freellmapi/cli/dist/index.js /usr/local/bin/freellmapi 2>/dev/null || true

# Copy add-on runtime files
COPY run.sh /
COPY nginx-ingress.conf /etc/nginx/http.d/ingress.conf

# Remove the default nginx site
RUN rm -f /etc/nginx/http.d/default.conf

RUN chmod a+x /run.sh

# Health check — the API should respond on the configured port
HEALTHCHECK --interval=30s --timeout=5s --start-period=15s --retries=3 \
    CMD curl -sf http://127.0.0.1:3001/v1/models >/dev/null || exit 1

CMD [ "/run.sh" ]
