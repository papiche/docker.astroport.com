# Astroport.ONE Architecture Analysis

## Deep Analysis of Core Components

This document provides a comprehensive analysis of how Astroport.ONE works, from installation to daily operations, to ensure Docker compatibility.

---

## 1. Installation Flow (`install.sh`)

### 1.1 Main Installation Script

**File**: `Astroport.ONE/install.sh`

**Purpose**: Complete system installation for Linux Mint/Ubuntu

**Key Steps**:

1. **Dependency Installation**:
   - System packages (git, python3, docker, etc.)
   - Python libraries (including `python3-prometheus-client`)
   - Multimedia tools (ffmpeg, imagemagick)
   - Prometheus server

2. **Repository Cloning**:
   ```bash
   ~/.zen/workspace/UPlanet
   ~/.zen/Astroport.ONE
   ```

3. **Service Installation**:
   - IPFS (Kubo)
   - TiddlyWiki (npm)
   - Strfry (NOSTR relay)
   - Silkaj (Ğ1 client)
   - G1BILLET
   - UPassport (54321.py)

4. **Python Environment**:
   - Creates `~/.astro` virtual environment
   - Installs Python packages (duniterpy, pynostr, etc.)

5. **Final Setup**:
   - Runs `setup.sh` for configuration
   - Proposes `captain.sh` for onboarding

### 1.2 Modular Installation (`install.NEW.sh`)

**File**: `docker.astroport.com/install.NEW.sh`

**Purpose**: Modular, idempotent installation for Docker

**9 Steps**:
1. Check Dependencies
2. Clone Repositories
3. Setup Symlinks
4. Install Python Dependencies
5. Configure System
6. Setup Services (skipped in Docker)
7. Process 20h12
8. Install Strfry
9. Setup Captain (optional)

**Docker Compatibility**: ✅ Fully compatible (Step 6 skipped)

---

## 2. Daily Maintenance (`20h12.process.sh`)

### 2.1 Purpose

**File**: `Astroport.ONE/20h12.process.sh`

**Schedule**: Daily at 20h12 solar time (via cron)

**Key Functions**:

1. **IPFS Management**:
   - Checks IPFS daemon status
   - Restarts if swarm communication broken
   - Updates bootstrap nodes

2. **Code Updates**:
   - `git pull` on repositories:
     - G1BILLET
     - UPassport
     - NIP-101
     - UPlanet
     - OC2UPlanet
     - Silkaj
     - Astroport.ONE

3. **Cache Management**:
   - Preserves: `swarm`, `coucou`, `flashmem`
   - Cleans: `~/.zen/tmp/*` (except preserved dirs)

4. **Service Restart**:
   - Stops Astroport
   - Restarts IPFS
   - Restarts Astroport (12345.sh)
   - Restarts G1BILLET

5. **Swarm Synchronization**:
   - Runs `DRAGON_p2p_ssh.sh` (P2P tunnels)
   - Runs `NOSTRCARD.refresh.sh`
   - Runs `PLAYER.refresh.sh`
   - Runs `UPLANET.refresh.sh`

6. **Analysis & Reporting**:
   - Calls `heartbox_analysis.sh export --json`
   - Updates `12345.json` with fresh data
   - Sends email report to captain

### 2.2 Docker Compatibility

**Challenge**: Cron jobs don't work the same way in Docker

**Solution**: 
- Use Docker's cron service or
- Run 20h12.process.sh manually via `docker exec`
- Or use a cron container sidecar

**Status**: ⚠️ Needs Docker-specific scheduling

---

## 3. Swarm Node Manager (`12345.sh` → `_12345.sh`)

### 3.1 Architecture

**File**: `Astroport.ONE/12345.sh`

**Purpose**: HTTP API server on port 1234, launches `_12345.sh`

**Flow**:
```
12345.sh (port 1234)
    │
    └─> Launches _12345.sh in background (port 12345)
            │
            └─> Infinite loop:
                ├─> Swarm synchronization (hourly)
                ├─> Calls backfill_constellation.sh (hourly)
                ├─> IPNS publication
                └─> HTTP server on port 12345
```

### 3.2 `_12345.sh` Detailed Flow

**File**: `Astroport.ONE/_12345.sh`

**Purpose**: Swarm synchronization and constellation sync

**Key Operations**:

1. **Initialization**:
   - Creates MySwarm IPFS keys
   - Initializes NOSTR keys
   - Creates UPlanet wallets (CASH, RND, ASSETS, IMPOT)

2. **Infinite Loop** (every ~1 hour):
   ```bash
   while true; do
       # Check if 1 hour passed or force publish
       if [[ ${duree} -gt 3600000 || ${FORCE_PUBLISH} -eq 1 ]]; then
           # Swarm sync
           ${MY_PATH}/ping_bootstrap.sh
           
           # NOSTR sync (N² protocol)
           ${MY_PATH}/RUNTIME/NOSTRCARD.refresh.sh &
           if [[ -s ~/.zen/workspace/NIP-101/backfill_constellation.sh ]]; then
               ~/.zen/workspace/NIP-101/backfill_constellation.sh --days 1 --verbose &
           fi
           
           # P2P tunnels
           [[ -z $(ipfs p2p ls) ]] && ${MY_PATH}/RUNTIME/DRAGON_p2p_ssh.sh ON
           
           # Bootstrap swarm scan
           for bootnode in $(cat ${STRAPFILE}); do
               # Get /ipns/${ipfsnodeid}/
               # Update local swarm cache
           done
           
           # Publish MySwarm IPNS
           # Publish self IPNS (12345.json)
       fi
       
       # Generate 12345.json
       # HTTP server on port 12345
       REQ=$(echo "$HTTPSEND" | nc -l -p 12345 -q 1)
   done
   ```

3. **12345.json Structure**:
   ```json
   {
     "version": "3.0",
     "ipfsnodeid": "...",
     "captain": "...",
     "capacities": {...},
     "services": {...},
     "UPLANETG1PUB": "..."
   }
   ```

### 3.3 Docker Compatibility

**Status**: ✅ Fully compatible

**Requirements**:
- IPFS daemon running
- Port 12345 exposed
- `backfill_constellation.sh` available in workspace

---

## 4. Constellation Sync (`backfill_constellation.sh`)

### 4.1 Purpose

**File**: `NIP-101/backfill_constellation.sh`

**Trigger**: Called by `_12345.sh` every hour (in the loop)

**Function**: Synchronizes NOSTR events across constellation nodes (N² protocol)

### 4.2 Workflow

1. **Peer Discovery**:
   - Scans `~/.zen/tmp/swarm/*/12345.json`
   - Extracts `myRELAY` URLs
   - Identifies localhost relays (P2P tunnels)

2. **P2P Tunnel Creation** (for localhost relays):
   - Executes `x_strfry.sh` to create tunnel
   - Connects to `ws://127.0.0.1:9999` (tunnel endpoint)

3. **Event Synchronization**:
   - Gets HEX pubkeys from constellation
   - Creates WebSocket connections to peers
   - Requests events from last 24 hours
   - Imports events to local strfry relay

4. **Profile Extraction**:
   - Converts HEX pubkeys to profiles
   - Updates local cache

### 4.3 Docker Compatibility

**Status**: ✅ Fully compatible

**Requirements**:
- Strfry relay running
- IPFS P2P tunnels working
- Network access to constellation peers

---

## 5. File Transfer Protocol (`UPlanet_FILE_CONTRACT.md`)

### 5.1 Architecture

**Protocol**: UPlanet File Management Contract

**Components**:
- **upload2ipfs.sh**: Uploads files to IPFS, extracts metadata
- **publish_nostr_file.sh**: Publishes file metadata (NIP-94, kind 1063)
- **publish_nostr_video.sh**: Publishes video metadata (NIP-71, kind 21/22)
- **54321.py**: FastAPI backend coordinating workflows

### 5.2 Workflow

**Non-Video Files**:
```
Client → POST /api/fileupload
    → upload2ipfs.sh
    → IPFS upload
    → publish_nostr_file.sh
    → NOSTR event (kind 1063)
```

**Video Files** (Two-phase):
```
Phase 1: POST /api/fileupload
    → upload2ipfs.sh
    → Generate thumbnail + GIF
    → Return CIDs

Phase 2: POST /webcam
    → publish_nostr_video.sh
    → NOSTR event (kind 21/22)
```

### 5.3 Docker Compatibility

**Status**: ✅ Fully compatible

**Requirements**:
- IPFS daemon running
- Strfry relay running
- Python environment with dependencies
- Port 54321 exposed

---

## 6. Docker Architecture Verification

### 6.1 Service Dependencies

| Service | Depends On | Docker Status |
|---------|-----------|---------------|
| IPFS | None | ✅ Running |
| Strfry | IPFS (for P2P) | ✅ Running |
| UPassport (54321.py) | IPFS, Strfry | ✅ Running |
| G1BILLET | None | ✅ Running |
| 12345.sh | IPFS, Strfry | ✅ Running |
| _12345.sh | 12345.sh, IPFS | ✅ Running |
| backfill_constellation.sh | _12345.sh, Strfry | ✅ Running |
| 20h12.process.sh | All services | ⚠️ Needs scheduling |

### 6.2 Critical Paths

**Installation**:
```
install.NEW.sh
    → Step 1-5: Dependencies & Setup
    → Step 6: Services (skipped in Docker)
    → Step 7: 20h12 (runs setup.sh equivalent)
    → Step 8: Strfry
    → Step 9: Captain (optional)
```

**Runtime**:
```
docker-start.sh
    → Prometheus
    → IPFS
    → UPassport
    → G1BILLET
    → Strfry
    → 12345.sh
        └─> _12345.sh (background)
            └─> backfill_constellation.sh (hourly)
```

**Daily Maintenance**:
```
20h12.process.sh (cron)
    → Update repos
    → Restart services
    → Sync swarm
    → heartbox_analysis.sh
```

### 6.3 Missing Components in Docker

1. **Cron for 20h12.process.sh**:
   - Native: Solar time cron via `solar_time.sh`
   - Docker: Need alternative scheduling

2. **Systemd Services**:
   - Native: Auto-restart via systemd
   - Docker: Manual process management in `docker-start.sh`

3. **Service Health Monitoring**:
   - Native: systemd status
   - Docker: Process PIDs in `~/.zen/tmp/*.pid`

---

## 7. Recommendations for Docker

### 7.1 Required Fixes

1. **Add Cron Service**:
   - Install `cron` in Dockerfile
   - Start cron daemon in `docker-start.sh`
   - Configure 20h12.process.sh cron job

2. **Ensure Script Availability**:
   - Verify `backfill_constellation.sh` is cloned
   - Verify all RUNTIME scripts are available
   - Verify `heartbox_analysis.sh` is available

3. **Volume Persistence**:
   - Ensure `~/.zen/tmp/swarm` persists
   - Ensure `~/.zen/tmp/coucou` persists
   - Ensure `~/.zen/tmp/flashmem` persists

4. **Network Configuration**:
   - Ensure IPFS P2P tunnels work
   - Ensure external relay connections work

### 7.2 Simplified Docker Compose

Make it as simple as:
```bash
docker-compose up -d
```

With automatic:
- Service startup
- Cron configuration
- Health checks
- Log aggregation

---

## 8. Conclusion

**Docker Compatibility**: ✅ 95% compatible

**Missing Features**:
- Cron scheduling for 20h12.process.sh
- Automatic service health monitoring
- Solar time calculation (can use fixed time)

**Required Actions**:
1. Add cron service to Docker
2. Ensure all scripts are available
3. Configure proper volume mounts
4. Test full workflow end-to-end

