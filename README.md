# 🚀 Astroport.ONE Docker Installation

**One-command deployment of a decentralized cooperative internet node**

[![Docker](https://img.shields.io/badge/Docker-Ready-blue)](https://www.docker.com/)
[![License](https://img.shields.io/badge/License-AGPL--3.0-green)](LICENSE)
[![Prometheus](https://img.shields.io/badge/Monitoring-Prometheus-orange)](http://localhost:9090)

> **Deploy your own sovereign internet node in minutes** - IPFS + NOSTR + UPlanet ẐEN + N² protocol stack with Docker Compose. Become a co-owner of free software commons, not just a consumer.

## 📝 Short Description

**Astroport.ONE Docker** provides a complete, production-ready Docker installation for the Astroport.ONE Fat Layer Protocol - a decentralized infrastructure that combines IPFS, NOSTR, UPlanet ẐEN cooperative economy, and N² constellation sync. Install your own cooperative internet node with a single command: `docker-compose up -d`.

**Key Features:**
- 🐳 **One-command installation** - `docker-compose up -d` and you're ready
- 🤝 **Cooperative model** - Become a co-manager of free software commons
- 📊 **Built-in monitoring** - Prometheus + Node Exporter included
- 💾 **Persistent storage** - All caches and data automatically persisted
- 🔄 **Automated sync** - Hourly N² constellation sync, daily maintenance
- 🌐 **Full protocol stack** - IPFS, NOSTR relay, UPassport API, Swarm Manager

---

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

**Economic Monitoring**: [Relay Live Calculator](https://ipfs.copylaradio.com/ipns/copylaradio.com/economy.html)

### 🌍 International Legal Frameworks & UPlanet Types

Astroport.ONE supports two UPlanet types configured via `~/.ipfs/swarm.key`:

- **ORIGIN** (default): No swarm.key - Original UPlanet network
- **ẐEN**: With swarm.key - Cooperative ẐEN network with enhanced features

**We invite communities worldwide to create legal framework models** adapted to their country's cooperative and cryptocurrency regulations. These models can be integrated into future UPlanet ẐEN implementations.

#### Creating Country-Specific Legal Models

**Why?** Each country has different:
- Cooperative laws (SCIC in France, Cooperatives in other countries)
- Cryptocurrency regulations
- Tax frameworks
- Data protection requirements (GDPR, local equivalents)
- Environmental obligations (ORE equivalents)

**How to Contribute:**

1. **Study your country's legal framework**:
   - Cooperative/association laws
   - Cryptocurrency regulations
   - Tax obligations
   - Data protection laws
   - Environmental protection mechanisms

2. **Create a legal model document**:
   - Document the cooperative structure
   - Define the economic model (3×1/3 rule adaptation)
   - Specify compliance requirements
   - Include templates for legal documents

3. **Submit your model**:
   - Create a pull request to the Astroport.ONE repository
   - Include documentation in your country's language
   - Provide examples and templates
   - Reference applicable laws and regulations

**Example Structure for Legal Model:**

```markdown
# UPlanet ẐEN Legal Framework - [Country Name]

## Cooperative Structure
- Legal form: [SCIC, Cooperative, Association, etc.]
- Registration requirements
- Governance model

## Economic Model
- Currency conversion (ẐEN ↔ Local currency)
- Tax obligations
- Accounting requirements
- Surplus distribution (3×1/3 adaptation)

## Compliance
- Cryptocurrency regulations
- Data protection (GDPR/local equivalent)
- KYC/AML requirements
- Reporting obligations

## Environmental Framework
- ORE equivalents (if applicable)
- Environmental obligations
- Verification mechanisms

## Templates
- Articles of association
- Membership agreements
- Service contracts
```

**Setting UPlanet Type:**

```bash
# For ORIGIN (default - no swarm.key)
# Just install normally, no swarm.key needed

# For ẐEN (cooperative network)
# Place swarm.key at ~/.ipfs/swarm.key
# Or set SWARM_KEY_PATH environment variable during installation
export SWARM_KEY_PATH=/path/to/swarm.key
./install.NEW.sh
```

**Resources:**
- [ZEN.ECONOMY.readme.md](https://github.com/papiche/Astroport.ONE/blob/master/RUNTIME/ZEN.ECONOMY.readme.md) - Economic model reference
- [ZEN.COOPERATIVE.3x1-3.sh](https://github.com/papiche/Astroport.ONE/blob/master/RUNTIME/ZEN.COOPERATIVE.3x1-3.sh) - Surplus distribution script
- [Economic Guide (FR)](extra/ECONOMIE_ASTROPORT.md) - French economic guide
- [Economic Guide (EN)](extra/ECONOMIE_ASTROPORT.en.md) - English economic guide
- [Economic Guide (ES)](extra/ECONOMIE_ASTROPORT.es.md) - Spanish economic guide
- [Economic Guide (ZH)](extra/ECONOMIE_ASTROPORT.zh.md) - Chinese economic guide

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
git clone https://github.com/papiche/docker.astroport.com.git
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

### Publishing to GitHub Container Registry

You can publish the Docker image to [GitHub Container Registry (ghcr.io)](https://docs.github.com/fr/packages/working-with-a-github-packages-registry/working-with-the-container-registry) for easy distribution and versioning.

#### Prerequisites

1. **Create a Personal Access Token (classic)** with `write:packages` scope:
   - Go to: https://github.com/settings/tokens/new?scopes=write:packages
   - Save the token as an environment variable:
   ```bash
   export CR_PAT=YOUR_TOKEN
   ```

2. **Authenticate to GitHub Container Registry**:
   ```bash
   echo $CR_PAT | docker login ghcr.io -u USERNAME --password-stdin
   ```

#### Build and Tag Image

```bash
# Build the image
./docker-build.sh -t astroport-one:latest

# Tag for GitHub Container Registry
# Replace NAMESPACE with your GitHub username or organization
docker tag astroport-one:latest ghcr.io/NAMESPACE/astroport-one:latest
docker tag astroport-one:latest ghcr.io/NAMESPACE/astroport-one:v1.0.0  # Version tag
```

#### Push Image

```bash
# Push latest version
docker push ghcr.io/NAMESPACE/astroport-one:latest

# Push versioned tag
docker push ghcr.io/NAMESPACE/astroport-one:v1.0.0
```

#### Pull and Use Published Image

```bash
# Pull from GitHub Container Registry
docker pull ghcr.io/NAMESPACE/astroport-one:latest

# Use in docker-compose.yml
# Update the image reference:
services:
  astroport:
    image: ghcr.io/NAMESPACE/astroport-one:latest
    # ... rest of configuration
```

#### Pull by Digest (Recommended for Production)

For production use, pull by digest to ensure you're always using the exact same image:

```bash
# Get digest SHA
docker inspect ghcr.io/NAMESPACE/astroport-one:latest | grep Digest

# Pull by digest
docker pull ghcr.io/NAMESPACE/astroport-one@sha256:82jf9a84u29hiasldj289498uhois8498hjs29hkuhs
```

#### Add Labels to Dockerfile (Recommended)

To automatically link the image to your repository, add these labels to your `Dockerfile`:

```dockerfile
LABEL org.opencontainers.image.source=https://github.com/NAMESPACE/docker.astroport.com
LABEL org.opencontainers.image.description="Astroport.ONE Docker - Decentralized cooperative internet node"
LABEL org.opencontainers.image.licenses=AGPL-3.0
```

Or add labels at build time:

```bash
docker build \
  --label "org.opencontainers.image.source=https://github.com/NAMESPACE/docker.astroport.com" \
  --label "org.opencontainers.image.description=Astroport.ONE Docker - Decentralized cooperative internet node" \
  --label "org.opencontainers.image.licenses=AGPL-3.0" \
  -t ghcr.io/NAMESPACE/astroport-one:latest .
```

#### GitHub Actions Workflow

You can automate publishing with GitHub Actions. Create `.github/workflows/docker-publish.yml`:

```yaml
name: Build and Push Docker Image

on:
  push:
    tags:
      - 'v*'
  workflow_dispatch:

jobs:
  build-and-push:
    runs-on: ubuntu-latest
    permissions:
      contents: read
      packages: write
    
    steps:
      - name: Checkout repository
        uses: actions/checkout@v4
      
      - name: Set up Docker Buildx
        uses: docker/setup-buildx-action@v3
      
      - name: Log in to GitHub Container Registry
        uses: docker/login-action@v3
        with:
          registry: ghcr.io
          username: ${{ github.actor }}
          password: ${{ secrets.GITHUB_TOKEN }}
      
      - name: Extract metadata
        id: meta
        uses: docker/metadata-action@v5
        with:
          images: ghcr.io/${{ github.repository_owner }}/astroport-one
          tags: |
            type=ref,event=branch
            type=ref,event=pr
            type=semver,pattern={{version}}
            type=semver,pattern={{major}}.{{minor}}
            type=sha
      
      - name: Build and push
        uses: docker/build-push-action@v5
        with:
          context: .
          file: ./Dockerfile
          push: true
          tags: ${{ steps.meta.outputs.tags }}
          labels: |
            org.opencontainers.image.source=https://github.com/${{ github.repository }}
            org.opencontainers.image.description=Astroport.ONE Docker - Decentralized cooperative internet node
            org.opencontainers.image.licenses=AGPL-3.0
```

**Note**: The Container registry has a 10 GB size limit for each layer and a 10 minute timeout limit for uploads.

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

The Docker installation includes **full monitoring capabilities** with Prometheus, matching the native installation. Monitor your node's health, performance, and economic metrics in real-time.

### ⭐ Star this repository to help us track adoption!

**Your stars help us monitor the growth of the decentralized cooperative internet.** We track repository stars as a metric of community adoption and project health. Every star counts! ⭐

### Access Prometheus Dashboard

Once your Astroport node is running, access the monitoring dashboard:

- **Prometheus Web UI**: http://localhost:9090
  - Query metrics, create alerts, visualize data
  - Pre-configured dashboards for system metrics
  - Economic metrics (ẐEN transactions, user counts)
  
- **Node Exporter Metrics**: http://localhost:9100/metrics
  - Raw system metrics (CPU, memory, disk, network)
  - Exported in Prometheus format

### What You Can Monitor

**System Metrics:**
- CPU, memory, and disk usage
- Network traffic and connections
- IPFS node performance
- NOSTR relay activity

**Economic Metrics:**
- ẐEN wallet balances
- MULTIPASS and ZEN Card user counts
- PAF (Participation Aux Frais) payments
- Cooperative surplus allocation (3×1/3 rule)

**Protocol Metrics:**
- N² constellation sync status
- IPFS content requests
- NOSTR event processing
- Swarm node connectivity

### Using heartbox_analysis.sh

The `heartbox_analysis.sh` script provides detailed system analysis using Prometheus metrics:

```bash
# Export JSON analysis (uses Prometheus metrics)
docker exec -it astroport-one ~/.zen/Astroport.ONE/tools/heartbox_analysis.sh export --json

# Update cache and generate report
docker exec -it astroport-one ~/.zen/Astroport.ONE/tools/heartbox_analysis.sh update

# View system health summary
docker exec -it astroport-one ~/.zen/Astroport.ONE/tools/heartbox_analysis.sh
```

### Prometheus Configuration

Prometheus configuration is automatically created at:
- `~/.zen/config/prometheus.yml`

The default configuration scrapes:
- **Node Exporter** (localhost:9100) - System metrics
- **Astroport API** (localhost:12345) - Application metrics
- **IPFS** (localhost:5001) - IPFS node metrics
- **Strfry** (localhost:7777) - NOSTR relay metrics

### Example Queries

Try these Prometheus queries in the web UI:

```promql
# CPU usage
100 - (avg(irate(node_cpu_seconds_total{mode="idle"}[5m])) * 100)

# Memory usage percentage
(1 - (node_memory_MemAvailable_bytes / node_memory_MemTotal_bytes)) * 100

# Disk usage percentage
(1 - (node_filesystem_avail_bytes / node_filesystem_size_bytes)) * 100

# IPFS peers count
ipfs_bitswap_peers

# NOSTR events processed
rate(nostr_events_total[5m])
```

### Monitoring Best Practices

1. **Set up alerts** in Prometheus for critical metrics (disk space, service downtime)
2. **Export metrics** to external monitoring systems (Grafana, etc.)
3. **Regular health checks** using `heartbox_analysis.sh`
4. **Track economic metrics** to monitor cooperative health

**💡 Tip**: Bookmark http://localhost:9090 to quickly check your node's health!

## 📚 Related Documentation

### Core Documentation
- [README.DOCKER.md](README.DOCKER.md) - Detailed Docker documentation
- [Installation Scripts](scripts/) - Individual installation step scripts
- [Uninstallation Scripts](scripts/uninstall/) - Uninstallation step scripts
- [ZEN.ECONOMY.readme.md](https://github.com/papiche/Astroport.ONE/blob/master/RUNTIME/ZEN.ECONOMY.readme.md) - Complete economic model documentation
- [UPlanet Cooperative](https://ipfs.copylaradio.com/ipns/copylaradio.com/entrance.html) - Cooperative website and information

### Complementary Resources

#### 📖 Self-Hosting Guide
- **[Libérez-vous du Cloud - Formation UPlanet](extra/Libérez-vous_du_Cloud_Formation_UPlanet.pdf)** (48 pages)
  - Complete guide on self-hosting and digital freedom
  - Explains Docker, Nextcloud, Pi-hole, local AI, and more
  - Philosophical context: why decentralize and regain control
  - Perfect for understanding the "why" behind Astroport.ONE
  - Also available: [ODT version](extra/Libérez-vous_du_Cloud_Formation_UPlanet.odt) | [JPG preview](extra/Libérez-vous%20du%20Cloud_Formation_UPlanet.jpg)

#### 💰 Economic Calculators

Plan your Astroport deployment and calculate potential revenues with our economic models:

**📊 Interactive Web Simulators** (Recommended):
- **[Satellite Economy Simulator](https://ipfs.copylaradio.com/ipns/copylaradio.com/economy.html)** - Real-time economic calculator for a single satellite node
  - Calculate revenues, costs, and break-even points
  - Adjust MULTIPASS and ZEN Card pricing
  - Visualize cooperative surplus and 3×1/3 allocation
  - Interactive sliders and instant calculations

- **[Constellation Economy Simulator](https://ipfs.copylaradio.com/ipns/copylaradio.com/economy.Constellation.html)** - Full network economic model
  - Model entire constellations (1 Hub + 24 Satellites)
  - Calculate team costs (developers, community managers)
  - Project ecological impact (forest acquisition)
  - Analyze network-scale economics and ROI
  - Pre-configured scenarios (Satellite Local, Regional Constellation, Mega-Constellation)

**📥 Downloadable Spreadsheets** (Advanced):
- **[Satellite Economy.ods](extra/Satellite%20Economy.ods)** - Offline economic model for a satellite node (Raspberry Pi 5)
  - Revenue calculations (MULTIPASS + ZEN Cards)
  - Infrastructure costs (PAF, electricity, internet)
  - Cooperative surplus and 3×1/3 allocation
  - ROI projections and break-even analysis
  - Customizable formulas for your specific scenario

- **[SWARM Economy.ods](extra/SWARM_Economy.ods)** - Offline economic model for a swarm network
  - Network-scale economics
  - Inter-satellite flows
  - HUB coordination benefits
  - Collective network projections

**📖 How to use**: See economic guides for detailed instructions, examples, and country-specific legal considerations:
- 🇫🇷 [Economic Guide (FR)](extra/ECONOMIE_ASTROPORT.md) - French economic guide
- 🇬🇧 [Economic Guide (EN)](extra/ECONOMIE_ASTROPORT.en.md) - English economic guide (US, UK, Canada, Australia)
- 🇪🇸 [Economic Guide (ES)](extra/ECONOMIE_ASTROPORT.es.md) - Spanish economic guide (Spain, Latin America)
- 🇨🇳 [Economic Guide (ZH)](extra/ECONOMIE_ASTROPORT.zh.md) - Chinese economic guide (China, Hong Kong, Taiwan, Singapore)

**💡 Tip**: Start with the web simulators for quick calculations, then download the ODS files for advanced planning and offline analysis.

#### 📊 Analysis
- [Document Analysis](extra/ANALYSE_DOCUMENTS.md) - Detailed analysis of complementary resources

## 👨‍💻 Developer Platform

Astroport.ONE provides a complete **developer platform** for building decentralized applications with MULTIPASS authentication, IPFS storage, NOSTR social features, and advanced identity systems.

### 🌐 Web Developer Platform

**Access**: [https://u.copylaradio.com/dev](https://u.copylaradio.com/dev) (or `http://127.0.0.1:54321/dev` for local)

The developer platform provides interactive documentation and testing tools for:

1. **MULTIPASS Authentication** (NIP-07, NIP-42)
   - Decentralized login with NOSTR keys
   - No passwords, no email, no central database
   - Automatic authentication verification
   - Integration examples with `common.js` API

2. **Decentralized File Publishing** (IPFS + NOSTR)
   - Upload files to IPFS and publish metadata on NOSTR
   - Support for images (NIP-94, kind 1063), videos (NIP-71, kinds 21/22), audio, documents
   - SHA256 tracking and provenance chain
   - Automatic metadata extraction

3. **Social Interactions** (NIP-25, Comments)
   - Add likes, reactions, comments, and shares
   - Real-time social features
   - Threaded comments (kind 1111 - NIP-22)

4. **Real-time Messaging** (NIP-01, WebSocket)
   - Live chat using NIP-28 (Public Chat Channels)
   - Geographic chat rooms (UMAP-based)
   - Real-time message synchronization

5. **Integration Examples**
   - NostrTube (decentralized video platform)
   - Theater Mode (immersive video player)
   - Playlists (NIP-51 playlist management)

**Quick Start for Developers**:
```html
<!-- 1. Include common.js -->
<script src="https://ipfs.copylaradio.com/ipns/copylaradio.com/common.js"></script>

<!-- 2. Add login button -->
<button onclick="loginWithMultipass()">Connect with MULTIPASS</button>

<!-- 3. Use authenticated user -->
<script>
async function loginWithMultipass() {
  const pubkey = await connectNostr();
  console.log('User connected:', pubkey);
  
  // Now you can use all NOSTR features
  await publishNote('Hello from my app!');
  await uploadPhotoToIPFS(file);
  await sendLike(eventId, authorPubkey);
}
</script>
```

**Common.js API**: `https://ipfs.copylaradio.com/ipns/copylaradio.com/common.js`

### 🔐 Decentralized Identity (DID)

**Documentation**: [DID_IMPLEMENTATION.md](https://github.com/papiche/Astroport.ONE/blob/master/DID_IMPLEMENTATION.md)

Astroport.ONE implements **W3C DID Core v1.1** compliant decentralized identities:

- **DID Method**: `did:nostr:{HEX_PUBLIC_KEY}`
- **Source of Truth**: NOSTR relays (kind 30800 - NIP-101)
- **Twin Keys**: Single seed generates G1, NOSTR, Bitcoin, Monero keys
- **SSSS 3/2 Secret Sharing**: 3 parts, 2 required for recovery
- **MULTIPASS**: User-controlled authorization (UCAN implementation)
- **ZEN Card**: Cooperative membership with DID integration
- **France Connect Compliance**: KYC-verified users can access French public services

**Key Features**:
- ✅ W3C DID Core v1.1 compliant
- ✅ Nostr-native DID resolution (kind 30800)
- ✅ Automatic DID updates on transactions
- ✅ WoT Duniter identification (0.01Ğ1 transaction)
- ✅ Environmental DIDs (UMAP cells with ORE contracts)
- ✅ Oracle permits integration (Verifiable Credentials)

**Usage**:
```bash
# Create MULTIPASS (generates DID automatically)
./make_NOSTRCARD.sh user@example.com picture.png 48.85 2.35

# Manage DID
./did_manager_nostr.sh update user@example.com MULTIPASS 50 5.0
./did_manager_nostr.sh fetch user@example.com
./did_manager_nostr.sh sync user@example.com
```

### 🌱 Environmental Obligations (ORE System)

**Documentation**: [ORE_SYSTEM.md](https://github.com/papiche/Astroport.ONE/blob/master/docs/ORE_SYSTEM.md)

The **ORE (Obligations Réelles Environnementales)** system creates a decentralized environmental cadastre where geographic cells (UMAP) have their own DIDs and environmental contracts.

**Key Features**:
- **UMAP DIDs**: Each 0.01°×0.01° cell (≈1.2 km²) gets `did:nostr:{umap_hex}`
- **Environmental Contracts**: Obligations attached to UMAP DIDs (e.g., "maintain 80% forest coverage")
- **Verification**: Satellite/IoT verification or human verification via VDO.ninja
- **Economic Rewards**: Ẑen distributed from cooperative ASSETS wallet
- **Cost Reduction**: < 1€ vs 6,500-19,000€ for traditional notarized ORE

**NOSTR Event Kinds**:
- **Kind 30800**: UMAP DID Documents (NIP-101)
- **Kind 30312**: ORE Meeting Space (persistent geographic space)
- **Kind 30313**: ORE Verification Meeting (scheduled verification sessions)

**Usage**:
```bash
# Activate ORE mode for a UMAP
./ore_system.py activate --lat 48.8566 --lon 2.3522 --contract "maintain_forest_80"

# Verify compliance
./ore_system.py verify --umap_hex abc123... --method satellite

# Distribute reward
./UPLANET.official.sh -p umap@example.com ORE_REWARD -m 10
```

### 🔐 Oracle System (Permits & Licenses)

**Documentation**: [ORACLE_SYSTEM_FULL.md](https://github.com/papiche/Astroport.ONE/blob/master/docs/ORACLE_SYSTEM_FULL.md)

The **Oracle System** enables decentralized permit/license management based on Web of Trust (WoT) with multi-signature validation.

**Key Features**:
- **Multi-Signature Validation**: 3-15 attestations required (depending on permit type)
- **W3C Verifiable Credentials**: Standards-compliant credentials
- **NOSTR Storage**: All permits stored on NOSTR relays (kinds 30500-30503)
- **Economic Integration**: Ẑen rewards for permit holders
- **Self-Regulating**: Competence validated by existing holders

**Available Permit Types**:
- **PERMIT_ORE_V1**: ORE Environmental Verifier (5 attestations, 3 years)
- **PERMIT_DRIVER**: Driver's License WoT Model (12 attestations, 15 years)
- **PERMIT_WOT_DRAGON**: UPlanet Authority (3 attestations, unlimited)
- **PERMIT_MEDICAL_FIRST_AID**: First Aid Provider (8 attestations, 2 years)
- **PERMIT_BUILDING_ARTISAN**: Building Artisan (10 attestations, 5 years)
- **PERMIT_EDUCATOR_COMPAGNON**: Compagnon Educator (12 attestations, unlimited)
- **PERMIT_FOOD_PRODUCER**: Local Food Producer (6 attestations, 3 years)
- **PERMIT_MEDIATOR**: Community Mediator (15 attestations, 5 years)

**NOSTR Event Kinds**:
- **Kind 30500**: Permit Definition (published by UPLANETNAME.G1)
- **Kind 30501**: Permit Request (published by applicant)
- **Kind 30502**: Permit Attestation (published by expert attesters)
- **Kind 30503**: Permit Credential (W3C VC, published by UPLANETNAME.G1)

**Web Interface**: `http://127.0.0.1:54321/oracle` (or `https://u.copylaradio.com/oracle`)

**API Usage**:
```bash
# Request a permit
curl -X POST "${uSPOT}/api/permit/request" \
  -H "Content-Type: application/json" \
  -d '{
    "permit_definition_id": "PERMIT_ORE_V1",
    "applicant_npub": "npub1...",
    "statement": "I have 5 years experience in environmental assessment"
  }'

# Attest a request (requires NIP-42 auth)
curl -X POST "${uSPOT}/api/permit/attest" \
  -H "Content-Type: application/json" \
  -d '{
    "request_id": "a1b2c3d4",
    "attester_npub": "npub1...",
    "statement": "I have personally verified their competence"
  }'
```

### 📁 File Management Contract

**Documentation**: [UPlanet_FILE_CONTRACT.md](https://github.com/papiche/Astroport.ONE/blob/master/Astroport.ONE/docs/UPlanet_FILE_CONTRACT.md)

The **UPlanet File Management Contract** provides decentralized file storage with IPFS and metadata publishing via NOSTR.

**Key Features**:
- **IPFS Storage**: Content-addressed file storage with CID generation
- **Provenance Tracking**: SHA256-based deduplication and upload chain
- **Type-Specific Metadata**: Automatic extraction for images, audio, video
- **NIP-94/71 Compliance**: Standard NOSTR event types for file metadata
- **RFC 8785 Canonicalization**: Deterministic JSON for signature consistency

**File Types Supported**:
- **Images** (NIP-94, kind 1063): Dimensions, thumbnail generation
- **Videos** (NIP-71, kinds 21/22): Duration, dimensions, thumbnail, animated GIF
- **Audio** (NIP-94, kind 1063): Duration, codec information
- **Documents** (NIP-94, kind 1063): Basic metadata

**API Endpoints**:
- `POST /api/fileupload` - Upload any file to IPFS
- `POST /webcam` - Publish video metadata to NOSTR (two-phase workflow)

**Usage Example**:
```bash
# Upload image
curl -X POST http://127.0.0.1:54321/api/fileupload \
  -F "file=@image.png" \
  -F "npub=npub1..."

# Upload video (two-phase)
# Phase 1: Upload to IPFS
curl -X POST http://127.0.0.1:54321/api/fileupload \
  -F "file=@video.mp4" \
  -F "npub=npub1..."

# Phase 2: Publish with metadata
curl -X POST http://127.0.0.1:54321/webcam \
  -F "ipfs_cid=QmVIDEO..." \
  -F "title=My Video" \
  -F "description=Video description" \
  -F "latitude=48.8566" \
  -F "longitude=2.3522" \
  -F "publish_nostr=true" \
  -F "npub=npub1..."
```

### 🎬 NostrTube Developer Documentation

**Documentation**: [README.NostrTube.DEV.md](https://github.com/papiche/Astroport.ONE/blob/master/Astroport.ONE/docs/README.NostrTube.DEV.md)

NostrTube is a decentralized video platform built on Astroport.ONE infrastructure.

**Features**:
- Video storage on IPFS (censorship-resistant)
- Metadata on NOSTR (decentralized social network)
- Sovereign identity (MULTIPASS authentication)
- Geographic discovery (UMAP geolocation)
- N² Protocol (constellation sync for content discovery)

**Access**:
- **Web Interface**: `https://u.copylaradio.com/youtube?html=1`
- **Portal**: `https://ipfs.copylaradio.com/ipns/copylaradio.com/entrance.html`
- **UPlanet Index**: `https://u.copylaradio.com/index`

### 📚 Developer Resources

**Core Documentation**:
- [DID_IMPLEMENTATION.md](https://github.com/papiche/Astroport.ONE/blob/master/DID_IMPLEMENTATION.md) - Complete DID system architecture
- [ORE_SYSTEM.md](https://github.com/papiche/Astroport.ONE/blob/master/docs/ORE_SYSTEM.md) - Environmental obligations system
- [ORACLE_SYSTEM_FULL.md](https://github.com/papiche/Astroport.ONE/blob/master/docs/ORACLE_SYSTEM_FULL.md) - Permit/license management
- [UPlanet_FILE_CONTRACT.md](https://github.com/papiche/Astroport.ONE/blob/master/Astroport.ONE/docs/UPlanet_FILE_CONTRACT.md) - File management protocol
- [README.NostrTube.DEV.md](https://github.com/papiche/Astroport.ONE/blob/master/Astroport.ONE/docs/README.NostrTube.DEV.md) - NostrTube development guide

**Web Platform**:
- [Developer Platform](https://u.copylaradio.com/dev) - Interactive developer documentation and testing
- [Common.js API](https://ipfs.copylaradio.com/ipns/copylaradio.com/common.js) - JavaScript SDK for NOSTR/IPFS integration

**API Endpoints** (available at `http://127.0.0.1:54321`):
- `/api/fileupload` - File upload to IPFS
- `/api/test-nostr` - NOSTR authentication verification
- `/api/permit/*` - Oracle permit system (11 routes)
- `/oracle` - Oracle web interface
- `/dev` - Developer platform documentation

**NOSTR NIPs Supported**:
- NIP-01: Basic Protocol
- NIP-07: Browser Extension
- NIP-22: Comments (kind 1111)
- NIP-25: Reactions (kind 7)
- NIP-28: Public Chat Channels (kind 42)
- NIP-42: Authentication (kind 22242)
- NIP-71: Video Events (kinds 21/22)
- NIP-94: File Metadata (kind 1063)
- NIP-101: DID Documents (kind 30800)

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

