# ⚠️  WARNING: This Dockerfile is AI-generated and needs to be tested
# Docker image for Astroport.ONE installation using install.NEW.sh
# This creates a containerized environment for Astroport.ONE

FROM ubuntu:22.04

# Avoid interactive prompts during package installation
ENV DEBIAN_FRONTEND=noninteractive
ENV TZ=Europe/Paris

# Install base dependencies
RUN apt-get update && apt-get install -y \
    git \
    curl \
    wget \
    python3 \
    python3-pip \
    python3-venv \
    jq \
    sudo \
    systemd \
    systemd-sysv \
    build-essential \
    g++ \
    make \
    libssl-dev \
    zlib1g-dev \
    liblmdb-dev \
    libflatbuffers-dev \
    libsecp256k1-dev \
    libzstd-dev \
    netcat-traditional \
    bc \
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
RUN mkdir -p /home/astroport/.zen/{workspace,tmp,logs,config}

# Run installation (non-interactive mode)
# Note: Step 6 (systemd services) is skipped in Docker as systemd doesn't run in containers
# Step 8 (strfry) may need manual compilation
RUN /home/astroport/install.NEW.sh \
    --skip-step 6 \
    --workspace /home/astroport/.zen/workspace || true

# Copy startup script for Docker
COPY --chown=astroport:astroport docker-start.sh /home/astroport/
RUN chmod +x /home/astroport/docker-start.sh

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
EXPOSE 54321 8080 7777 12345

# Set default command to start all services
CMD ["/home/astroport/docker-start.sh"]

# Labels
LABEL maintainer="Astroport.ONE"
LABEL description="Astroport.ONE installation container"
LABEL version="1.0.0"
LABEL ai-generated="true"

