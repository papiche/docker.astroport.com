# ⚠️  WARNING: This Dockerfile is AI-generated and needs to be tested
# Docker image for Astroport.ONE installation using install.NEW.sh
# This creates a containerized environment for Astroport.ONE

FROM ubuntu:22.04

# Avoid interactive prompts during package installation
ENV DEBIAN_FRONTEND=noninteractive
ENV TZ=Europe/Paris

# Install base dependencies (matching native install.sh)
RUN apt-get update && apt-get install -y \
    git \
    zip \
    ssss \
    make \
    cmake \
    docker.io \
    docker-compose \
    hdparm \
    iptables \
    fail2ban \
    openssh-server \
    parallel \
    npm \
    shellcheck \
    multitail \
    netcat-traditional \
    ncdu \
    chromium \
    miller \
    inotify-tools \
    curl \
    wget \
    net-tools \
    mosquitto \
    libsodium* \
    libcurl4-openssl-dev \
    libgpgme-dev \
    libffi-dev \
    python3 \
    python3-pip \
    python3-venv \
    python3-setuptools \
    python3-wheel \
    python3-dotenv \
    python3-gpg \
    python3-jwcrypto \
    python3-brotli \
    python3-aiohttp \
    python3-prometheus-client \
    python3-tk \
    jq \
    sudo \
    build-essential \
    g++ \
    libssl-dev \
    zlib1g-dev \
    liblmdb-dev \
    libflatbuffers-dev \
    libsecp256k1-dev \
    libzstd-dev \
    bc \
    prometheus \
    prometheus-node-exporter \
    cron \
    && rm -rf /var/lib/apt/lists/*

# Create a non-root user for Astroport.ONE
RUN useradd -m -s /bin/bash astroport && \
    echo "astroport ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers && \
    usermod -aG sudo astroport

# Set working directory
WORKDIR /home/astroport

# Copy installation scripts
COPY --chown=astroport:astroport install.NEW.sh /home/astroport/
COPY --chown=astroport:astroport scripts/ /home/astroport/scripts/
COPY --chown=astroport:astroport templates/ /home/astroport/templates/

# Make scripts executable
RUN chmod +x /home/astroport/install.NEW.sh && \
    chmod +x /home/astroport/scripts/*.sh && \
    chmod +x /home/astroport/scripts/uninstall/*.sh

# Switch to non-root user
USER astroport

# Set environment variables
ENV HOME=/home/astroport
ENV WORKSPACE_DIR=/home/astroport/.zen/workspace

# Create .zen directory structure
RUN mkdir -p /home/astroport/.zen/{workspace,tmp,logs,config} && \
    mkdir -p /home/astroport/.zen/tmp/prometheus

# Run installation (non-interactive mode)
# Note: Step 6 (systemd services) is skipped in Docker as systemd doesn't run in containers
# Step 8 (strfry) may need manual compilation
RUN /home/astroport/install.NEW.sh \
    --skip-step 6 \
    --workspace /home/astroport/.zen/workspace || true

# Copy startup script for Docker
COPY --chown=astroport:astroport docker-start.sh /home/astroport/
RUN chmod +x /home/astroport/docker-start.sh

# Copy cron setup script
COPY --chown=astroport:astroport scripts/docker-cron-setup.sh /home/astroport/
RUN chmod +x /home/astroport/docker-cron-setup.sh

# Copy Astroport.ONE scripts if they exist (12345.sh and _12345.sh)
# These will be available after installation
USER root
RUN mkdir -p /home/astroport/.zen/Astroport.ONE && \
    mkdir -p /home/astroport/.zen/logs && \
    chown -R astroport:astroport /home/astroport/.zen
USER astroport

# Expose common ports used by Astroport.ONE
# 54321: uSPOT API (UPassport)
# 8080: IPFS Gateway
# 7777: NOSTR Relay (strfry)
# 12345: SYNC (Astroport Swarm Node Manager)
# 9090: Prometheus metrics server
EXPOSE 54321 8080 7777 12345 9090

# Set default command to start all services
CMD ["/home/astroport/docker-start.sh"]

# Labels for GitHub Container Registry
# Update org.opencontainers.image.source with your repository URL
LABEL org.opencontainers.image.source="https://github.com/papiche/docker.astroport.com"
LABEL org.opencontainers.image.description="Astroport.ONE Docker - Decentralized cooperative internet node (IPFS + NOSTR + UPlanet ẐEN + N²)"
LABEL org.opencontainers.image.licenses="AGPL-3.0"
LABEL maintainer="Astroport.ONE"
LABEL version="1.0.0"

