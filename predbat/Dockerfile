# Use a recent HA add-on base (Supervisor will substitute {arch})
ARG BUILD_FROM=ghcr.io/home-assistant/{arch}-addon-base:latest
FROM $BUILD_FROM

# Use bash for consistency with your scripts
SHELL ["/bin/bash", "-o", "pipefail", "-c"]

# Install Python + venv + pip (Debian base)
RUN apt-get update \
 && apt-get install -y --no-install-recommends \
      python3 \
      python3-venv \
      python3-pip \
      ca-certificates \
 && rm -rf /var/lib/apt/lists/*

# Create isolated environment and make it default for the image
RUN python3 -V && python3 -m venv /opt/venv
ENV PATH="/opt/venv/bin:${PATH}"

# Workdir for any runtime data
WORKDIR /app_data

# Copy files that rarely change first (better layer cache)
COPY requirements.txt /tmp/requirements.txt

# Install Python deps into the venv
RUN pip install --no-cache-dir --upgrade pip \
 && pip install --no-cache-dir -r /tmp/requirements.txt

# Now copy the rest of the rootfs (scripts, svc, app files, etc.)
COPY rootfs /

# Ensure run script is executable
RUN chmod a+x /run.sh

# Labels (unchanged except they’ll now reflect your build)
ARG BUILD_ARCH
ARG BUILD_DATE
ARG BUILD_DESCRIPTION
ARG BUILD_NAME
ARG BUILD_REF
ARG BUILD_REPOSITORY
ARG BUILD_VERSION
LABEL \
    io.hass.name="${BUILD_NAME}" \
    io.hass.description="${BUILD_DESCRIPTION}" \
    io.hass.arch="${BUILD_ARCH}" \
    io.hass.type="addon" \
    io.hass.version=${BUILD_VERSION} \
    maintainer="springfall2008 (https://github.com/springfall2008)" \
    org.opencontainers.image.title="${BUILD_NAME}" \
    org.opencontainers.image.description="${BUILD_DESCRIPTION}" \
    org.opencontainers.image.vendor="Springfall2008" \
    org.opencontainers.image.authors="springfall2008 (https://github.com/springfall2008)" \
    org.opencontainers.image.licenses="MIT" \
    org.opencontainers.image.url="https://github.com/springfall2008" \
    org.opencontainers.image.source="https://github.com/${BUILD_REPOSITORY}" \
    org.opencontainers.image.documentation="https://github.com/${BUILD_REPOSITORY}/blob/main/README.md" \
    org.opencontainers.image.created=${BUILD_DATE} \
    org.opencontainers.image.revision=${BUILD_REF} \
    org.opencontainers.image.version=${BUILD_VERSION}
