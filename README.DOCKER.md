# 🐳 Astroport.ONE Docker Installation

⚠️ **WARNING**: These Docker files are AI-generated and need to be tested thoroughly before production use.

## 📋 Overview

This directory contains Docker configuration files to containerize Astroport.ONE installation using the modular `install.NEW.sh` script.

## 🚀 Quick Start

### Build the Docker Image

```bash
# Build production image
./docker-build.sh

# Build development image
./docker-build.sh --dev

# Build with custom tag
./docker-build.sh -t v1.0.0
```

### Run with Docker Compose

```bash
# Start all services
docker-compose up -d

# View logs
docker-compose logs -f

# Stop services
docker-compose down
```

### Run with Docker

```bash
# Run container
docker run -it \
  -p 54321:54321 \
  -p 8080:8080 \
  -p 7777:7777 \
  -p 12345:12345 \
  -v astroport-data:/home/astroport/.zen \
  astroport-one:latest

# Run with shell access
docker run -it --entrypoint /bin/bash astroport-one:latest
```

## 📁 Files

- **Dockerfile** - Production Docker image
- **Dockerfile.dev** - Development Docker image (includes dev tools)
- **docker-compose.yml** - Docker Compose configuration
- **docker-build.sh** - Build script for Docker images
- **.dockerignore** - Files to exclude from Docker build context

## 🔧 Configuration

### Environment Variables

- `WORKSPACE_DIR` - Workspace directory (default: `/home/astroport/.zen/workspace`)
- `TZ` - Timezone (default: `Europe/Paris`)
- `NON_INTERACTIVE` - Non-interactive mode (default: `true`)

### Ports

- **54321** - uSPOT API (UPassport)
- **8080** - IPFS Gateway
- **7777** - NOSTR Relay (strfry)
- **12345** - SYNC (Astroport Swarm Node Manager - _12345.sh)

### Volumes

- `astroport-data` - Main data directory (`~/.zen`)
- `astroport-workspace` - Workspace directory
- `astroport-ipfs` - IPFS data directory

## ⚠️ Limitations

1. **Systemd Services**: Step 6 (Setup Services) is skipped in Docker as systemd doesn't run in containers
2. **Strfry Installation**: Step 8 (Install Strfry) may be skipped as it requires compilation
3. **Network**: Some features may require host network mode for better connectivity

## 🛠️ Development

### Development Image

The development image includes additional tools:
- vim, nano (editors)
- htop (monitoring)
- net-tools, iputils-ping (network tools)

### Building Development Image

```bash
./docker-build.sh --dev -t dev
```

### Interactive Development

```bash
docker run -it \
  -v $(pwd):/workspace \
  astroport-one-dev:dev \
  /bin/bash
```

## 📝 Notes

- The installation runs automatically during image build
- Some steps are skipped for container compatibility
- Data persistence is handled via Docker volumes
- The container runs as non-root user `astroport`

## 🔍 Troubleshooting

### Check Installation

```bash
docker exec -it astroport-one /bin/bash
cd ~/.zen/workspace
ls -la
```

### View Logs

```bash
docker-compose logs astroport
```

### Rebuild Image

```bash
docker-compose build --no-cache
docker-compose up -d
```

## 📚 Related Documentation

- [install.NEW.sh](../install.NEW.sh) - Main installation script
- [uninstall.NEW.sh](../uninstall.NEW.sh) - Uninstallation script

