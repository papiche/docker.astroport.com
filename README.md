# Astroport.ONE Fat Layer Protocol

**IPFS + NOSTR + UPlanet ẐEN + N²**

Astroport.ONE is a decentralized infrastructure stack that combines multiple protocols to create a sovereign, resilient, and cooperative internet layer. This repository provides Docker-based installation and deployment tools for Astroport.ONE stations.

## 🌐 Overview

Astroport.ONE integrates four core protocols:

- **IPFS** - Distributed content storage and retrieval
- **NOSTR** - Decentralized social networking protocol
- **UPlanet ẐEN** - Cooperative cryptocurrency and economic layer
- **N²** - Constellation sync protocol for decentralized content discovery

## 🤝 Cooperative Model & Common Good

**Astroport.ONE is a cooperative infrastructure that makes users co-managers of free and open-source software commons.**

By installing an Astroport station, you become part of a cooperative ecosystem where:
- **You are a co-owner**, not just a consumer
- **You participate in governance** (1 person = 1 vote)
- **You share in the benefits** of the cooperative surplus
- **You contribute to a common good** (free software, ecological investments)

The cooperative distributes its surplus according to the **3×1/3 rule**:
- **1/3 Treasury** - Operational liquidity and stability
- **1/3 R&D** - Research and development of free software
- **1/3 Assets** - Real-world investments (forests, regenerative projects)

Learn more: [UPlanet Cooperative](https://ipfs.copylaradio.com/ipns/copylaradio.com/entrance.html)

## 💾 Storage Requirements & Economic Model

### Storage Capacity Planning

**Important**: Astroport.ONE requires **several terabytes of storage** to operate effectively as a cooperative node.

#### Storage Consumption per User

- **MULTIPASS** (Digital Studio): **1-10 GB** per user
  - uDRIVE storage (10 GB base)
  - NOSTR identity data
  - IPFS content cache
  - Constellation sync data

- **ZEN Card** (Digital Apartment + Ownership): **128 GB** per user
  - NextCloud premium storage
  - Additional services and data

#### Recommended Infrastructure

| Station Type | Storage | Capacity | Use Case |
|-------------|---------|----------|----------|
| **Satellite** (Raspberry Pi 5) | **4 TB NVMe** | 10 Sociétaires + 50 MULTIPASS | Local cooperative node |
| **Hub** (PC Gamer) | **8+ TB** | 24 Sociétaires + 250 MULTIPASS | Central coordination node |

**Minimum Requirements**: At least **1 TB** for testing, but **4+ TB recommended** for production use.

### Economic Model (ẐEN Economy)

Astroport.ONE operates on the **ẐEN cooperative currency**, backed by the Ğ1 blockchain:

- **MULTIPASS**: 1 Ẑ/week (≈ 1€/week) - Digital studio rental
- **ZEN Card**: 50 Ẑ/year (≈ 50€/year) - Cooperative membership + premium services
- **Captain Remuneration**: 2× PAF (Participation Aux Frais) for node management
- **Cooperative Surplus**: Distributed via 3×1/3 rule (see above)

**Automated Economic Scripts**:
- `ZEN.ECONOMY.sh` - Weekly PAF payments and 4-week burn cycles
- `ZEN.COOPERATIVE.3x1-3.sh` - Surplus allocation (3×1/3 rule)
- `NOSTRCARD.refresh.sh` - MULTIPASS rent collection
- `PLAYER.refresh.sh` - ZEN Card rent collection

**Economic Simulator**: [Live Calculator](https://ipfs.copylaradio.com/ipns/copylaradio.com/economy.html)

### Persistent Storage

The following cache directories are **automatically persisted** via Docker volumes:

- `~/.zen/tmp/$IPFSNODEID` - Node-specific cache
- `~/.zen/tmp/coucou` - Economic logs and data
- `~/.zen/tmp/flashmem` - Temporary flash memory cache
- `~/.zen/tmp/swarm` - IPFS swarm cache

All data in `~/.zen` is persisted in the `astroport-data` Docker volume.

## 🚀 Quick Start

### Prerequisites

- Docker and Docker Compose installed
- Linux-based system (tested on Ubuntu/Debian)
- **At least 2GB RAM** and **1TB disk space** (minimum)
- **4+ TB storage recommended** for production use

### Installation

#### Using Docker Compose (Recommended)

```bash
# Clone the repository
git clone https://github.com/papiche/Astroport.ONE.git
cd docker.astroport.com

# Build and start services
docker-compose up -d

# View logs
docker-compose logs -f
```

#### Using Installation Script

```bash
# Run the modular installation script
./install.NEW.sh

# Or with custom workspace
./install.NEW.sh --workspace /custom/path
```

#### Using Docker Build Script

```bash
# Build production image
./docker-build.sh

# Build development image
./docker-build.sh --dev

# Build with custom tag
./docker-build.sh -t v1.0.0
```

## 📋 Installation Steps

The modular installation script (`install.NEW.sh`) performs the following steps:

1. **Check Dependencies** - Verifies required tools are installed
2. **Clone Repositories** - Clones or updates git repositories
3. **Setup Symlinks** - Creates symbolic links for easy access
4. **Install Python Dependencies** - Installs Python packages
5. **Configure System** - Sets up configuration files from templates
6. **Setup Services** - Configures systemd services
7. **Process 20h12** - Runs additional installation steps
8. **Install Strfry** - Installs and configures NOSTR relay
9. **Setup Captain** - Captain onboarding (optional, interactive)

### Running Specific Steps

```bash
# Run only a specific step
./install.NEW.sh --only-step 1

# Skip specific steps
./install.NEW.sh --skip-step 6 --skip-step 8

# Verbose output
./install.NEW.sh --verbose
```

## 🔧 Configuration

### Ports

- **54321** - uSPOT API (UPassport)
- **8080** - IPFS Gateway
- **7777** - NOSTR Relay (strfry)
- **12345** - SYNC (Astroport Swarm Node Manager)
- **9090** - Prometheus metrics server
- **9100** - Prometheus Node Exporter

### Environment Variables

- `WORKSPACE_DIR` - Workspace directory (default: `~/.zen/workspace`)
- `TZ` - Timezone (default: `Europe/Paris`)
- `NON_INTERACTIVE` - Non-interactive mode (default: `true`)

### Docker Volumes

The following volumes ensure data persistence:

- **`astroport-data`** - Main data directory (`~/.zen`)
  - Contains all user data, wallets, game state, and caches
  - Includes persistent caches: `tmp/$IPFSNODEID`, `tmp/coucou`, `tmp/flashmem`, `tmp/swarm`
  - **Size**: Grows with number of users (1-10 GB per MULTIPASS, 128 GB per ZEN Card)
  
- **`astroport-workspace`** - Workspace directory
  - Repository clones and development files
  
- **`astroport-ipfs`** - IPFS data directory
  - Distributed content storage and cache
  - **Size**: Grows with IPFS content (can reach several TB)

**⚠️ Storage Warning**: Ensure your Docker host has sufficient disk space. A production node with 50 MULTIPASS users can require **500 GB - 1 TB** just for user data, plus IPFS cache which can grow significantly.

## 🐳 Docker Usage

### Docker Compose

```bash
# Start all services
docker-compose up -d

# Stop services
docker-compose down

# View logs
docker-compose logs -f astroport

# Rebuild and restart
docker-compose build --no-cache
docker-compose up -d
```

### Docker Run

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

## 🗑️ Uninstallation

To completely remove Astroport.ONE:

```bash
# Run the uninstallation script
./uninstall.NEW.sh

# Non-interactive mode
./uninstall.NEW.sh --non-interactive

# Run specific uninstall step
./uninstall.NEW.sh --only-step 1
```

The uninstallation script performs:

1. Stop all services
2. Remove service files
3. Remove cron jobs
4. Remove sudoers entries
5. Remove binaries
6. Restore system configuration
7. Remove desktop shortcuts
8. Clean bashrc
9. Cleanup directories

## 📁 Project Structure

```
docker.astroport.com/
├── install.NEW.sh          # Main installation script
├── uninstall.NEW.sh        # Uninstallation script
├── docker-compose.yml      # Docker Compose configuration
├── Dockerfile              # Production Docker image
├── Dockerfile.dev          # Development Docker image
├── docker-build.sh         # Docker build script
├── docker-start.sh         # Container startup script
├── .dockerignore           # Docker ignore patterns
├── scripts/                # Modular installation scripts
│   ├── 01_check_dependencies.sh
│   ├── 02_clone_repositories.sh
│   ├── 03_setup_symlinks.sh
│   ├── 04_install_python_deps.sh
│   ├── 05_configure_system.sh
│   ├── 06_setup_services.sh
│   ├── 07_process_20h12.sh
│   ├── 08_install_strfry.sh
│   ├── 09_setup_captain.sh
│   ├── install.lib.sh
│   └── uninstall/          # Uninstallation scripts
└── templates/              # Configuration templates
    ├── astroport.service.tpl
    ├── config.json.tpl
    ├── g1billet.service.tpl
    ├── ipfs.service.tpl
    └── strfry.service.tpl
```

## 🔍 Troubleshooting

### Check Installation

```bash
# Docker
docker exec -it astroport-one /bin/bash
cd ~/.zen/workspace
ls -la

# Native installation
cd ~/.zen/workspace
ls -la
```

### View Service Logs

```bash
# Docker
docker-compose logs -f astroport

# Native (systemd)
journalctl -u upassport -f
journalctl -u ipfs -f
journalctl -u strfry -f
```

### Check Service Status

```bash
# Docker
docker ps

# Native
sudo systemctl status upassport
sudo systemctl status ipfs
sudo systemctl status strfry
```

### Rebuild from Scratch

```bash
# Docker
docker-compose down -v
docker-compose build --no-cache
docker-compose up -d

# Native
./uninstall.NEW.sh
./install.NEW.sh
```

## 🛠️ Development

### Development Image

The development image includes additional tools:

- vim, nano (editors)
- htop (monitoring)
- net-tools, iputils-ping (network tools)

```bash
# Build development image
./docker-build.sh --dev -t dev

# Run development container
docker run -it \
  -v $(pwd):/workspace \
  astroport-one-dev:dev \
  /bin/bash
```

## ⚠️ Important Notes

1. **Systemd Services**: Step 6 (Setup Services) is skipped in Docker as systemd doesn't run in containers. Services are started manually via `docker-start.sh`
2. **Strfry Installation**: Step 8 (Install Strfry) may require compilation and additional dependencies
3. **Prometheus**: Prometheus server and Node Exporter are installed and started automatically, matching the native installation
4. **Network**: Some features may require host network mode for better connectivity
5. **Data Persistence**: Always use Docker volumes for data persistence. All caches (`tmp/$IPFSNODEID`, `tmp/coucou`, `tmp/flashmem`, `tmp/swarm`) are automatically persisted
6. **Non-Root User**: The container runs as non-root user `astroport`
7. **heartbox_analysis.sh**: Now works with Prometheus integration, similar to native installation
8. **Storage Planning**: Plan for several terabytes of storage. Each MULTIPASS user consumes 1-10 GB, each ZEN Card user consumes 128 GB, plus IPFS cache
9. **Cooperative Model**: By installing Astroport, you become a co-manager of free and open-source software commons. You participate in governance and share in cooperative benefits

## 📊 Monitoring with Prometheus

The Docker installation includes Prometheus for system monitoring, matching the native installation:

### Access Prometheus

- **Web UI**: http://localhost:9090
- **Node Exporter**: http://localhost:9100/metrics

### Using heartbox_analysis.sh

The `heartbox_analysis.sh` script works with Prometheus in Docker:

```bash
# Export JSON analysis (uses Prometheus metrics)
docker exec -it astroport-one ~/.zen/Astroport.ONE/tools/heartbox_analysis.sh export --json

# Update cache
docker exec -it astroport-one ~/.zen/Astroport.ONE/tools/heartbox_analysis.sh update
```

### Prometheus Configuration

Prometheus configuration is automatically created at:
- `~/.zen/config/prometheus.yml`

The default configuration scrapes:
- Node Exporter metrics (localhost:9100)
- Astroport metrics (localhost:12345)

## 📚 Related Documentation

- [COMPARISON.md](COMPARISON.md) - Detailed comparison between native and Docker installations
- [README.DOCKER.md](README.DOCKER.md) - Detailed Docker documentation
- [Installation Scripts](scripts/) - Individual installation step scripts
- [Uninstallation Scripts](scripts/uninstall/) - Uninstallation step scripts
- [ZEN.ECONOMY.readme.md](../Astroport.ONE/RUNTIME/ZEN.ECONOMY.readme.md) - Complete economic model documentation
- [UPlanet Cooperative](https://ipfs.copylaradio.com/ipns/copylaradio.com/entrance.html) - Cooperative website and information

## 🤝 Contributing

This project is part of the Astroport.ONE ecosystem. Contributions are welcome!

## 📄 License

This project is part of the Astroport.ONE ecosystem and follows the same licensing terms.

## 🔗 Links

- **Astroport.ONE Repository**: https://github.com/papiche/Astroport.ONE
- **Installation URL**: https://install.astroport.com
- **UPlanet App**: http://127.0.0.1:8080/ipns/copylaradio.com

---

**⚠️ WARNING**: These scripts are AI-generated and need to be tested thoroughly before production use.

