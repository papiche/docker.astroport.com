#!/bin/bash
# Startup script for Astroport.ONE Docker container
# This script starts all services manually (systemd doesn't run in containers)

set -euo pipefail

# Colors
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

log_info() {
    echo -e "${BLUE}ℹ️  $1${NC}"
}

log_success() {
    echo -e "${GREEN}✅ $1${NC}"
}

log_warning() {
    echo -e "${YELLOW}⚠️  $1${NC}"
}

# Activate Python virtual environment if it exists
if [ -f "$HOME/.astro/bin/activate" ]; then
    source "$HOME/.astro/bin/activate"
    log_info "Python virtual environment activated"
fi

# Export PATH
export PATH="$HOME/.local/bin:$PATH"

# Create necessary directories
mkdir -p "$HOME/.zen/tmp" "$HOME/.zen/game/players/localhost" "$HOME/.zen/logs"

# Check if captain setup is needed (non-interactive mode for Docker)
# Set SETUP_CAPTAIN=true in docker-compose.yml to enable
# Required environment variables for captain setup:
#   - CAPTAIN_EMAIL: Email address for captain account
#   - CAPTAIN_LAT: Latitude (will be rounded to 0.01°)
#   - CAPTAIN_LON: Longitude (will be rounded to 0.01°)
#   - SWARM_KEY_PATH: Path to swarm.key file (for UPlanet ẐEN, optional)
#   - MJ_APIKEY_IPFS: IPFS path to retrieve MJ_APIKEY from (optional)
#   - UPLANET_TYPE: "ORIGIN" or "ZEN" (auto-detected from swarm.key if not set)
if [ "${SETUP_CAPTAIN:-false}" = "true" ]; then
    log_info "Running captain setup (non-interactive mode)..."
    
    # Check required parameters
    if [ -z "${CAPTAIN_EMAIL:-}" ]; then
        log_warning "CAPTAIN_EMAIL not set - skipping captain setup"
        log_info "Set CAPTAIN_EMAIL environment variable to enable captain setup"
    elif [ -z "${CAPTAIN_LAT:-}" ] || [ -z "${CAPTAIN_LON:-}" ]; then
        log_warning "CAPTAIN_LAT or CAPTAIN_LON not set - skipping captain setup"
        log_info "Set CAPTAIN_LAT and CAPTAIN_LON environment variables to enable captain setup"
    else
        SETUP_SCRIPT=""
        # Check in workspace first (where install.NEW.sh scripts are)
        if [ -f "$HOME/.zen/workspace/Astroport.ONE/scripts/09_setup_captain.sh" ]; then
            SETUP_SCRIPT="$HOME/.zen/workspace/Astroport.ONE/scripts/09_setup_captain.sh"
        elif [ -f "$HOME/.zen/Astroport.ONE/scripts/09_setup_captain.sh" ]; then
            SETUP_SCRIPT="$HOME/.zen/Astroport.ONE/scripts/09_setup_captain.sh"
        fi
        
        if [ -n "$SETUP_SCRIPT" ]; then
            # Run setup in non-interactive mode (will skip interactive prompts)
            # Export non-interactive flag and pass parameters
            export NON_INTERACTIVE=true
            log_info "Captain setup parameters:"
            log_info "  EMAIL: ${CAPTAIN_EMAIL}"
            log_info "  LAT: ${CAPTAIN_LAT} (will be rounded to 0.01°)"
            log_info "  LON: ${CAPTAIN_LON} (will be rounded to 0.01°)"
            [ -n "${SWARM_KEY_PATH:-}" ] && log_info "  SWARM_KEY_PATH: ${SWARM_KEY_PATH}"
            [ -n "${MJ_APIKEY_IPFS:-}" ] && log_info "  MJ_APIKEY_IPFS: ${MJ_APIKEY_IPFS}"
            [ -n "${UPLANET_TYPE:-}" ] && log_info "  UPLANET_TYPE: ${UPLANET_TYPE}"
            
            bash "$SETUP_SCRIPT" \
                "$HOME/.zen/workspace" \
                "${CAPTAIN_EMAIL}" \
                "${CAPTAIN_LAT}" \
                "${CAPTAIN_LON}" \
                "${SWARM_KEY_PATH:-}" \
                || log_warning "Captain setup may have failed"
        else
            log_warning "Captain setup script not found"
            log_info "Expected locations:"
            log_info "  - $HOME/.zen/workspace/Astroport.ONE/scripts/09_setup_captain.sh"
            log_info "  - $HOME/.zen/Astroport.ONE/scripts/09_setup_captain.sh"
        fi
    fi
fi

# Initialize PID variables
IPFS_PID=""
UPASSPORT_PID=""
G1BILLET_PID=""
STRFRY_PID=""
ASTROPORT_PID=""

# Start IPFS daemon in background if available
if command -v ipfs >/dev/null 2>&1; then
    log_info "Starting IPFS daemon..."
    ipfs daemon --enable-pubsub-experiment --enable-namesys-pubsub > "$HOME/.zen/logs/ipfs.log" 2>&1 &
    IPFS_PID=$!
    log_success "IPFS daemon started (PID: $IPFS_PID)"
    sleep 2  # Give IPFS time to start
fi

# Start UPassport (54321.py) in background if available
UPASSPORT_SCRIPT=""
if [ -f "$HOME/.zen/UPassport/54321.py" ]; then
    UPASSPORT_SCRIPT="$HOME/.zen/UPassport/54321.py"
elif [ -f "$HOME/.zen/workspace/UPassport/54321.py" ]; then
    UPASSPORT_SCRIPT="$HOME/.zen/workspace/UPassport/54321.py"
fi

if [ -n "$UPASSPORT_SCRIPT" ]; then
    log_info "Starting UPassport API (54321.py)..."
    cd "$(dirname "$UPASSPORT_SCRIPT")"
    python3 "$UPASSPORT_SCRIPT" > "$HOME/.zen/logs/upassport.log" 2>&1 &
    UPASSPORT_PID=$!
    log_success "UPassport started (PID: $UPASSPORT_PID)"
fi

# Start G1BILLET in background if available
G1BILLET_SCRIPT=""
if [ -f "$HOME/.zen/G1BILLET/G1BILLETS.sh" ]; then
    G1BILLET_SCRIPT="$HOME/.zen/G1BILLET/G1BILLETS.sh"
elif [ -f "$HOME/.zen/workspace/G1BILLET/G1BILLETS.sh" ]; then
    G1BILLET_SCRIPT="$HOME/.zen/workspace/G1BILLET/G1BILLETS.sh"
fi

if [ -n "$G1BILLET_SCRIPT" ]; then
    log_info "Starting G1BILLET API..."
    cd "$(dirname "$G1BILLET_SCRIPT")"
    bash "$G1BILLET_SCRIPT" daemon > "$HOME/.zen/logs/g1billet.log" 2>&1 &
    G1BILLET_PID=$!
    log_success "G1BILLET started (PID: $G1BILLET_PID)"
fi

# Start Strfry in background if available
if [ -f "$HOME/.zen/strfry/start.sh" ]; then
    log_info "Starting Strfry NOSTR relay..."
    cd "$HOME/.zen/strfry"
    bash start.sh > "$HOME/.zen/logs/strfry.log" 2>&1 &
    STRFRY_PID=$!
    log_success "Strfry started (PID: $STRFRY_PID)"
fi

# Start Astroport 12345.sh (which will launch _12345.sh)
# Check both symlink location and workspace location
ASTROPORT_SCRIPT=""
if [ -f "$HOME/.zen/Astroport.ONE/12345.sh" ]; then
    ASTROPORT_SCRIPT="$HOME/.zen/Astroport.ONE/12345.sh"
elif [ -f "$HOME/.zen/workspace/Astroport.ONE/12345.sh" ]; then
    ASTROPORT_SCRIPT="$HOME/.zen/workspace/Astroport.ONE/12345.sh"
fi

if [ -n "$ASTROPORT_SCRIPT" ]; then
    log_info "Starting Astroport API (12345.sh)..."
    cd "$(dirname "$ASTROPORT_SCRIPT")"
    bash "$ASTROPORT_SCRIPT" > "$HOME/.zen/logs/12345.log" 2>&1 &
    ASTROPORT_PID=$!
    log_success "Astroport 12345.sh started (PID: $ASTROPORT_PID)"
    log_info "This will automatically launch _12345.sh for swarm synchronization"
else
    log_warning "Astroport 12345.sh not found. Swarm synchronization will not work."
    log_info "Expected locations:"
    log_info "  - $HOME/.zen/Astroport.ONE/12345.sh"
    log_info "  - $HOME/.zen/workspace/Astroport.ONE/12345.sh"
fi

# Save PIDs for cleanup (only if services were started)
[ -n "$IPFS_PID" ] && echo "$IPFS_PID" > "$HOME/.zen/tmp/ipfs.pid" 2>/dev/null || true
[ -n "$UPASSPORT_PID" ] && echo "$UPASSPORT_PID" > "$HOME/.zen/tmp/upassport.pid" 2>/dev/null || true
[ -n "$G1BILLET_PID" ] && echo "$G1BILLET_PID" > "$HOME/.zen/tmp/g1billet.pid" 2>/dev/null || true
[ -n "$STRFRY_PID" ] && echo "$STRFRY_PID" > "$HOME/.zen/tmp/strfry.pid" 2>/dev/null || true
[ -n "$ASTROPORT_PID" ] && echo "$ASTROPORT_PID" > "$HOME/.zen/tmp/astroport.pid" 2>/dev/null || true

log_success "Services startup completed"
log_info "Services are running in background"
log_info "Check logs in: $HOME/.zen/logs/"

# Keep container running
log_info "Container is running. Press Ctrl+C to stop."
trap 'log_info "Stopping services..."; [ -n "$IPFS_PID" ] && kill $IPFS_PID 2>/dev/null || true; [ -n "$UPASSPORT_PID" ] && kill $UPASSPORT_PID 2>/dev/null || true; [ -n "$G1BILLET_PID" ] && kill $G1BILLET_PID 2>/dev/null || true; [ -n "$STRFRY_PID" ] && kill $STRFRY_PID 2>/dev/null || true; [ -n "$ASTROPORT_PID" ] && kill $ASTROPORT_PID 2>/dev/null || true; exit 0' INT TERM

# Wait for all background processes
wait

