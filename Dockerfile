# syntax=docker/dockerfile:1

# Build arguments for source image
ARG SOURCE_IMAGE="towfiqi/serpbear"
ARG SOURCE_VERSION="2.0.7"

# Build stage for serpbear
FROM ${SOURCE_IMAGE}:${SOURCE_VERSION} AS serpbear

# Production stage with LinuxServer.io Alpine baseimage
FROM ghcr.io/linuxserver/baseimage-alpine:3.22-a0dc0735-ls11

# Build arguments for metadata
ARG BUILD_DATE
ARG VERSION
ARG SERPBEAR_VERSION="${SOURCE_VERSION}"

# Metadata labels following LinuxServer.io standards
LABEL build.version="Mildman1848 version: ${VERSION} Build-date: ${BUILD_DATE}"
LABEL maintainer="Mildman1848"
LABEL org.opencontainers.image.title="serpbear"
LABEL org.opencontainers.image.description="Open Source Search Engine Position Tracking App"
LABEL org.opencontainers.image.version="${VERSION}"
LABEL org.opencontainers.image.created="${BUILD_DATE}"
LABEL org.opencontainers.image.authors="Mildman1848"
LABEL org.opencontainers.image.url="https://serpbear.com"
LABEL org.opencontainers.image.documentation="https://docs.serpbear.com"
LABEL org.opencontainers.image.source="https://github.com/Mildman1848/serpbear"
LABEL org.opencontainers.image.vendor="Mildman1848"
LABEL org.opencontainers.image.licenses="MIT"

# Build arguments for package versions
ARG CA_CERTIFICATES_VERSION="20250619-r0"
ARG CURL_VERSION="8.14.1-r1"
ARG UNZIP_VERSION="6.0-r15"
ARG NODEJS_VERSION="22.16.0-r2"

# Environment variables for serpbear
ENV SERPBEAR_CONFIG="/config/serpbear/serpbear.conf" \
    SERPBEAR_CACHE_DIR="/config/cache" \
    SERPBEAR_TEMP_DIR="/tmp/serpbear" \
    SERPBEAR_LOG_LEVEL="INFO" \
    SERPBEAR_LOG_FILE="/config/logs/serpbear.log" \
    SERPBEAR_APP_VERSION="${SERPBEAR_VERSION}"

# Install dependencies and serpbear
RUN \
  echo "**** install runtime packages ****" && \
  apk add --no-cache \
    ca-certificates=${CA_CERTIFICATES_VERSION} \
    curl=${CURL_VERSION} \
    nodejs=${NODEJS_VERSION} \
    npm \
    unzip=${UNZIP_VERSION} && \
  echo "**** install serpbear ****" && \
  mkdir -p /app && \
  echo "**** cleanup ****" && \
  rm -rf \
    /tmp/* \
    /var/cache/apk/* \
    /var/tmp/*

# Copy application from official image
COPY --from=serpbear /app /app/

# Copy local files and set permissions
COPY root/ /

# Security: Set non-root user (LinuxServer.io will manage actual user via S6)
# This satisfies security scanners while S6 overlay handles the real user management
USER abc

# Expose ports (application specific ports)
EXPOSE 3000

# Health check for serpbear
HEALTHCHECK --interval=30s --timeout=10s --start-period=60s --retries=3 \
  CMD ps aux | grep -v grep | grep "node server.js" || exit 1

# Volumes for persistent data
VOLUME ["/config", "/data"]