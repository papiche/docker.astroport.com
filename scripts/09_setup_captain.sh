#!/bin/bash
# Setup Captain - Post-installation initialization script
# This script orchestrates the captain onboarding process:
# 1. Configure UPlanet type (ORIGIN or ẐEN) via swarm.key
# 2. Retrieve MJ_APIKEY from IPFS (if available)
# 3. Create MULTIPASS using make_NOSTRCARD.sh (EMAIL + GPS rounded to 0.01°)
# 4. Create ZEN Card using VISA.new.sh
# 5. Configure cron for 20h12.process.sh using solar_time.sh
# 6. Run UPLANET.init.sh to initialize cooperative wallets
# 7. Run Ylevel.sh (mandatory for ẐEN, optional for ORIGIN)
# 8. Create .env file with proper configuration
# 9. Run UPLANET.official.sh for PAF armateur registration
#
# Usage:
#   ./09_setup_captain.sh [WORKSPACE_DIR] [EMAIL] [LAT] [LON] [SWARM_KEY_PATH]
#   Environment variables:
#     - CAPTAIN_EMAIL: Email for captain account
#     - CAPTAIN_LAT: Latitude (will be rounded to 0.01°)
#     - CAPTAIN_LON: Longitude (will be rounded to 0.01°)
#     - SWARM_KEY_PATH: Path to swarm.key file (for ẐEN)
#     - MJ_APIKEY_IPFS: IPFS path to retrieve MJ_APIKEY from
#     - UPLANET_TYPE: "ORIGIN" or "ZEN" (auto-detected from swarm.key if not set)

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${SCRIPT_DIR}/install.lib.sh"

# Parse arguments
WORKSPACE_DIR="${1:-${HOME}/.zen/workspace}"
CAPTAIN_EMAIL="${2:-${CAPTAIN_EMAIL:-}}"
CAPTAIN_LAT="${3:-${CAPTAIN_LAT:-}}"
CAPTAIN_LON="${4:-${CAPTAIN_LON:-}}"
SWARM_KEY_PATH="${5:-${SWARM_KEY_PATH:-}}"

# Astroport.ONE paths
ASTROPORT_DIR="${HOME}/.zen/Astroport.ONE"
ASTROPORT_WORKSPACE_DIR="${WORKSPACE_DIR}/Astroport.ONE"

# Find Astroport.ONE directory (symlink or workspace)
if [ -d "$ASTROPORT_DIR" ]; then
    ASTROPORT_PATH="$ASTROPORT_DIR"
elif [ -d "$ASTROPORT_WORKSPACE_DIR" ]; then
    ASTROPORT_PATH="$ASTROPORT_WORKSPACE_DIR"
else
    log_error "Astroport.ONE directory not found"
    log_info "Expected locations:"
    log_info "  - $ASTROPORT_DIR"
    log_info "  - $ASTROPORT_WORKSPACE_DIR"
    exit 1
fi

# Source my.sh for makecoord and other utilities
if [ -f "${ASTROPORT_PATH}/tools/my.sh" ]; then
    source "${ASTROPORT_PATH}/tools/my.sh"
fi

# Round GPS coordinates to 0.01° precision
round_gps() {
    local coord="$1"
    if [ -z "$coord" ]; then
        echo ""
        return
    fi
    
    # Use makecoord if available (from my.sh)
    if command -v makecoord >/dev/null 2>&1; then
        makecoord "$coord"
    elif command_exists bc; then
        # Round to 2 decimal places using bc
        echo "scale=2; ($coord + 0.005) / 1" | bc | awk '{printf "%.2f", $1}'
    else
        # Fallback: use awk for rounding
        echo "$coord" | awk '{printf "%.2f", $1}'
    fi
}

# Determine UPlanet type from swarm.key
determine_uplanet_type() {
    local swarm_key="${SWARM_KEY_PATH:-${HOME}/.ipfs/swarm.key}"
    
    if [ -n "${UPLANET_TYPE:-}" ]; then
        echo "${UPLANET_TYPE}"
        return
    fi
    
    # Check if swarm.key exists
    if [ -f "$swarm_key" ]; then
        log_info "swarm.key found at $swarm_key - UPlanet ẐEN mode"
        echo "ZEN"
    else
        log_info "No swarm.key found - UPlanet ORIGIN mode"
        echo "ORIGIN"
    fi
}

# Setup swarm.key for ẐEN
setup_swarm_key() {
    local uplanet_type="$1"
    local swarm_key="${HOME}/.ipfs/swarm.key"
    
    if [ "$uplanet_type" != "ZEN" ]; then
        log_info "UPlanet ORIGIN mode - skipping swarm.key setup"
        return 0
    fi
    
    # If swarm.key path provided, copy it
    if [ -n "${SWARM_KEY_PATH:-}" ] && [ -f "$SWARM_KEY_PATH" ]; then
        log_info "Copying swarm.key from $SWARM_KEY_PATH to $swarm_key"
        mkdir -p "${HOME}/.ipfs"
        cp "$SWARM_KEY_PATH" "$swarm_key"
        chmod 600 "$swarm_key"
        log_success "swarm.key configured for UPlanet ẐEN"
    elif [ ! -f "$swarm_key" ]; then
        log_warning "swarm.key not found and SWARM_KEY_PATH not provided"
        log_info "For UPlanet ẐEN, you need to provide swarm.key"
        log_info "You can:"
        log_info "  1. Set SWARM_KEY_PATH environment variable"
        log_info "  2. Place swarm.key at $swarm_key"
        log_info "  3. Or create a new UPlanet ẐEN network"
        return 1
    else
        log_info "swarm.key already exists at $swarm_key"
    fi
    
    return 0
}

# Retrieve MJ_APIKEY from IPFS
retrieve_mj_apikey() {
    local mj_apikey_file="${HOME}/.zen/MJ_APIKEY"
    
    # If MJ_APIKEY_IPFS is set, retrieve from IPFS
    if [ -n "${MJ_APIKEY_IPFS:-}" ]; then
        log_info "Retrieving MJ_APIKEY from IPFS: $MJ_APIKEY_IPFS"
        
        if command_exists ipfs; then
            if ipfs cat "$MJ_APIKEY_IPFS" > "$mj_apikey_file" 2>/dev/null; then
                chmod 600 "$mj_apikey_file"
                log_success "MJ_APIKEY retrieved from IPFS"
                return 0
            else
                log_warning "Failed to retrieve MJ_APIKEY from IPFS"
            fi
        else
            log_warning "IPFS not available - cannot retrieve MJ_APIKEY from IPFS"
        fi
    fi
    
    # Check if MJ_APIKEY already exists
    if [ -f "$mj_apikey_file" ]; then
        log_info "MJ_APIKEY already exists at $mj_apikey_file"
        return 0
    fi
    
    log_warning "MJ_APIKEY not configured"
    log_info "You can:"
    log_info "  1. Set MJ_APIKEY_IPFS environment variable to retrieve from IPFS"
    log_info "  2. Create $mj_apikey_file manually with:"
    log_info "     SENDER_EMAIL=your@email.com"
    log_info "     MJ_APIKEY_PUBLIC=your_public_key"
    log_info "     MJ_APIKEY_PRIVATE=your_private_key"
    
    return 0  # Don't fail if MJ_APIKEY is missing
}

# Create GPS file with rounded coordinates
create_gps_file() {
    local lat="$1"
    local lon="$2"
    local gps_file="${HOME}/.zen/GPS"
    
    if [ -z "$lat" ] || [ -z "$lon" ]; then
        log_warning "GPS coordinates not provided"
        return 1
    fi
    
    # Round coordinates to 0.01°
    local rounded_lat=$(round_gps "$lat")
    local rounded_lon=$(round_gps "$lon")
    
    log_info "Creating GPS file with coordinates: LAT=$rounded_lat, LON=$rounded_lon"
    
    cat > "$gps_file" << EOF
# GPS coordinates for captain (rounded to 0.01° precision)
LAT=$rounded_lat
LON=$rounded_lon
EOF
    
    log_success "GPS file created at $gps_file"
    return 0
}

# Create MULTIPASS using make_NOSTRCARD.sh
create_multipass() {
    local email="$1"
    local lat="$2"
    local lon="$3"
    
    if [ -z "$email" ]; then
        log_warning "Email not provided - skipping MULTIPASS creation"
        return 1
    fi
    
    # Check if MULTIPASS already exists
    if [ -d "${HOME}/.zen/game/nostr/${email}" ] && [ -f "${HOME}/.zen/game/nostr/${email}/G1PUBNOSTR" ]; then
        log_info "MULTIPASS already exists for $email"
        return 0
    fi
    
    local make_nostrcard_script="${ASTROPORT_PATH}/tools/make_NOSTRCARD.sh"
    
    if [ ! -f "$make_nostrcard_script" ]; then
        log_error "make_NOSTRCARD.sh not found at $make_nostrcard_script"
        return 1
    fi
    
    # Round coordinates to 0.01°
    local rounded_lat=$(round_gps "$lat")
    local rounded_lon=$(round_gps "$lon")
    
    log_info "Creating MULTIPASS for $email (LAT=$rounded_lat, LON=$rounded_lon)..."
    
    # Run make_NOSTRCARD.sh
    # Usage: make_NOSTRCARD.sh EMAIL [IMAGE|PASS] [LATITUDE] [LONGITUDE] [SALT] [PEPPER]
    if bash "$make_nostrcard_script" "$email" "fr" "$rounded_lat" "$rounded_lon"; then
        log_success "MULTIPASS created successfully"
        return 0
    else
        log_error "Failed to create MULTIPASS"
        return 1
    fi
}

# Create ZEN Card using VISA.new.sh
create_zencard() {
    local email="$1"
    local lat="$2"
    local lon="$3"
    
    if [ -z "$email" ]; then
        log_warning "Email not provided - skipping ZEN Card creation"
        return 1
    fi
    
    # Check if ZEN Card already exists
    if [ -d "${HOME}/.zen/game/players/${email}" ] && [ -f "${HOME}/.zen/game/players/${email}/.g1pub" ]; then
        log_info "ZEN Card already exists for $email"
        return 0
    fi
    
    # MULTIPASS is required for ZEN Card
    if [ ! -d "${HOME}/.zen/game/nostr/${email}" ] || [ ! -f "${HOME}/.zen/game/nostr/${email}/G1PUBNOSTR" ]; then
        log_error "MULTIPASS required for ZEN Card creation"
        log_info "Please create MULTIPASS first using make_NOSTRCARD.sh"
        return 1
    fi
    
    local visa_script="${ASTROPORT_PATH}/RUNTIME/VISA.new.sh"
    
    if [ ! -f "$visa_script" ]; then
        log_error "VISA.new.sh not found at $visa_script"
        return 1
    fi
    
    # Get NOSTR keys from MULTIPASS
    local nostr_secret="${HOME}/.zen/game/nostr/${email}/.secret.nostr"
    if [ ! -f "$nostr_secret" ]; then
        log_error "NOSTR secret not found for $email"
        return 1
    fi
    
    source "$nostr_secret"
    
    # Round coordinates to 0.01°
    local rounded_lat=$(round_gps "$lat")
    local rounded_lon=$(round_gps "$lon")
    
    log_info "Creating ZEN Card for $email (LAT=$rounded_lat, LON=$rounded_lon)..."
    
    # Generate SALT and PEPPER (or use from MULTIPASS if available)
    local salt="${SALT:-$(tr -dc 'a-zA-Z0-9' < /dev/urandom | fold -w42 | head -n1)}"
    local pepper="${PEPPER:-$(tr -dc 'a-zA-Z0-9' < /dev/urandom | fold -w42 | head -n1)}"
    
    # Get pseudo from email
    local pseudo=$(echo "$email" | cut -d'@' -f1)
    
    # Run VISA.new.sh
    # Usage: VISA.new.sh SALT PEPPER PLAYER PSEUDO LANG LAT LON NPUB HEX
    if bash "$visa_script" "$salt" "$pepper" "$email" "$pseudo" "fr" "$rounded_lat" "$rounded_lon" "${NPUB:-}" "${HEX:-}"; then
        log_success "ZEN Card created successfully"
        
        # Create symlink to .current
        if [ ! -e "${HOME}/.zen/game/players/.current" ]; then
            ln -s "${HOME}/.zen/game/players/${email}" "${HOME}/.zen/game/players/.current"
            log_success "Created .current symlink to captain account"
        fi
        
        return 0
    else
        log_error "Failed to create ZEN Card"
        return 1
    fi
}

# Check if captain is already configured
is_captain_configured() {
    local captain_file="${HOME}/.zen/game/players/.current/.player"
    if [ -f "$captain_file" ]; then
        local captain_email=$(cat "$captain_file" 2>/dev/null | tr -d '\n')
        if [ -n "$captain_email" ]; then
            return 0
        fi
    fi
    return 1
}

# Configure cron for 20h12.process.sh using solar_time.sh
configure_solar_cron() {
    log_info "Configuring solar time cron for 20h12.process.sh..."
    
    local solar_time_script="${ASTROPORT_PATH}/tools/solar_time.sh"
    local gps_file="${HOME}/.zen/GPS"
    
    if [ ! -f "$solar_time_script" ]; then
        log_warning "solar_time.sh not found at $solar_time_script"
        log_info "Skipping solar cron configuration"
        return 0
    fi
    
    # Check if GPS file exists
    if [ ! -f "$gps_file" ]; then
        log_warning "GPS file not found at $gps_file"
        log_info "Skipping solar cron configuration"
        return 0
    fi
    
    # Source GPS file to get coordinates
    source "$gps_file"
    
    if [ -z "${LAT:-}" ] || [ -z "${LON:-}" ]; then
        log_warning "LAT or LON not found in GPS file"
        return 0
    fi
    
    # Get timezone (default to system timezone)
    local tz="${TZ:-$(timedatectl show --property=Timezone --value 2>/dev/null || echo "Europe/Paris")}"
    
    # Run solar_time.sh to get cron schedule
    log_info "Calculating solar time for 20h12 (LAT=$LAT, LON=$LON, TZ=$tz)..."
    local cron_output=$("$solar_time_script" "$LAT" "$LON" "$tz" 2>/dev/null || echo "")
    
    if [ -z "$cron_output" ]; then
        log_warning "Failed to calculate solar time"
        return 0
    fi
    
    # Extract cron schedule from output (format: "MINUTE HOUR * * *")
    local cron_schedule=$(echo "$cron_output" | grep -E '^[0-9]+ [0-9]+ \* \* \*' | head -1)
    
    if [ -z "$cron_schedule" ]; then
        log_warning "Could not extract cron schedule from solar_time.sh output"
        return 0
    fi
    
    # Get 20h12.process.sh path
    local process_script="${ASTROPORT_PATH}/20h12.process.sh"
    if [ ! -f "$process_script" ]; then
        log_warning "20h12.process.sh not found at $process_script"
        return 0
    fi
    
    # Create cron entry
    local cron_entry="${cron_schedule} /bin/bash ${process_script} > /tmp/20h12.log 2>&1"
    
    # Check if cron entry already exists
    local temp_cron=$(mktemp)
    crontab -l > "$temp_cron" 2>/dev/null || touch "$temp_cron"
    
    if grep -q "20h12.process.sh" "$temp_cron" 2>/dev/null; then
        log_info "Cron entry for 20h12.process.sh already exists"
        log_info "Updating with new solar time schedule..."
        # Remove old entry
        grep -v "20h12.process.sh" "$temp_cron" > "${temp_cron}.new" || touch "${temp_cron}.new"
        mv "${temp_cron}.new" "$temp_cron"
    fi
    
    # Add new cron entry
    echo "$cron_entry" >> "$temp_cron"
    crontab "$temp_cron"
    rm -f "$temp_cron"
    
    log_success "Solar cron configured: $cron_schedule"
    log_info "20h12.process.sh will run daily at 20h12 solar time"
    
    return 0
}

# Create .env file with proper configuration
create_env_file() {
    log_info "Creating .env file..."
    
    local env_file="${ASTROPORT_PATH}/.env"
    local gps_file="${HOME}/.zen/GPS"
    
    # Check if .env already exists
    if [ -f "$env_file" ]; then
        log_info ".env file already exists at $env_file"
        log_info "Skipping .env creation (manual configuration may be needed)"
        return 0
    fi
    
    # Get domain (default to copylaradio.com)
    local domain="${MYDOMAIN:-copylaradio.com}"
    
    # Get IPFS node ID if available
    local ipfs_nodeid=""
    if command_exists ipfs; then
        ipfs_nodeid=$(ipfs config Identity.PeerID 2>/dev/null || echo "")
    fi
    
    # Get GPS coordinates if available
    local lat=""
    local lon=""
    if [ -f "$gps_file" ]; then
        source "$gps_file"
        lat="${LAT:-}"
        lon="${LON:-}"
    fi
    
    # Get UPlanet type
    local uplanet_type=$(determine_uplanet_type)
    local uplanet_name="EnfinLibre"
    if [ "$uplanet_type" = "ZEN" ]; then
        # Extract UPLANETNAME from swarm.key or use default
        uplanet_name="${UPLANETNAME:-UPlanetZen}"
    fi
    
    # Create .env file
    cat > "$env_file" << EOF
# Astroport.ONE Environment Configuration
# Generated by setup_captain.sh on $(date)

# UPlanet type
UPLANETNAME=${uplanet_name}

# Domain configuration
MYDOMAIN=${domain}

# IPFS configuration
myIPFS=\${myIPFS:-https://ipfs.${domain}}
IPFSNODEID=${ipfs_nodeid}

# Astroport configuration
myASTROPORT=https://astroport.${domain}

# uSPOT configuration
uSPOT=\${uSPOT:-https://uspot.${domain}}

# GPS coordinates (if available)
${lat:+LAT=$lat}
${lon:+LON=$lon}
EOF
    
    log_success ".env file created at $env_file"
    log_info "You may need to edit this file to customize your configuration"
    
    return 0
}

# Run UPLANET.init.sh to initialize wallets
initialize_uplanet_wallets() {
    log_info "Initializing UPlanet cooperative wallets..."
    
    local init_script="${ASTROPORT_PATH}/UPLANET.init.sh"
    
    if [ ! -f "$init_script" ]; then
        log_warning "UPLANET.init.sh not found at $init_script"
        log_info "Skipping wallet initialization"
        return 0
    fi
    
    # Run UPLANET.init.sh
    if bash "$init_script"; then
        log_success "UPlanet wallets initialized"
        return 0
    else
        log_warning "UPlanet wallet initialization may have failed"
        return 0  # Don't fail the whole script
    fi
}

# Run Ylevel.sh for X to Y level upgrade
run_ylevel_upgrade() {
    local uplanet_type="$1"
    local ylevel_script="${ASTROPORT_PATH}/tools/Ylevel.sh"
    
    if [ ! -f "$ylevel_script" ]; then
        log_warning "Ylevel.sh not found at $ylevel_script"
        log_info "Skipping Y level upgrade"
        return 0
    fi
    
    # Check if SSH key exists
    if [ ! -f "${HOME}/.ssh/id_ed25519" ]; then
        log_warning "SSH key not found. Y level upgrade requires SSH key."
        if [ "$uplanet_type" = "ZEN" ]; then
            log_error "Y level is MANDATORY for UPlanet ẐEN"
            return 1
        fi
        return 0
    fi
    
    # Check if already at Y level (has secret.NODE.dunikey)
    if [ -f "${HOME}/.zen/game/secret.NODE.dunikey" ]; then
        log_info "Y level already activated (secret.NODE.dunikey exists)"
        return 0
    fi
    
    if [ "$uplanet_type" = "ZEN" ]; then
        log_info "Y level is MANDATORY for UPlanet ẐEN"
        log_info "Running Ylevel.sh..."
        if bash "$ylevel_script"; then
            log_success "Y level upgrade completed"
            return 0
        else
            log_error "Y level upgrade failed - REQUIRED for UPlanet ẐEN"
            return 1
        fi
    else
        log_info "Y level upgrade available (optional for ORIGIN)"
        log_info "Y level enables:"
        log_info "  - SSH/IPFS key transmutation"
        log_info "  - NODE wallet (Armateur)"
        log_info "  - Enhanced security and identity management"
        
        # Check if running in non-interactive mode
        if [ "${NON_INTERACTIVE:-false}" = "true" ]; then
            log_info "Non-interactive mode: Skipping Y level upgrade (optional)"
            return 0
        fi
        
        echo ""
        read -p "Would you like to upgrade to Y level now? (y/N): " upgrade_choice
        
        if [[ "$upgrade_choice" =~ ^[Yy]$ ]]; then
            log_info "Running Ylevel.sh..."
            if bash "$ylevel_script"; then
                log_success "Y level upgrade completed"
            else
                log_warning "Y level upgrade may have failed"
            fi
        else
            log_info "Y level upgrade skipped. You can run it later with:"
            log_info "  bash $ylevel_script"
        fi
    fi
    
    return 0
}

# Run UPLANET.official.sh for PAF armateur registration
register_paf_armateur() {
    log_info "Registering PAF armateur and capital contribution..."
    
    local official_script="${ASTROPORT_PATH}/UPLANET.official.sh"
    
    if [ ! -f "$official_script" ]; then
        log_warning "UPLANET.official.sh not found at $official_script"
        log_info "Skipping PAF armateur registration"
        return 0
    fi
    
    # Check if captain is configured
    if ! is_captain_configured; then
        log_warning "Captain not configured yet"
        log_info "Skipping PAF armateur registration (run captain setup first)"
        return 0
    fi
    
    local captain_email=$(cat "${HOME}/.zen/game/players/.current/.player" 2>/dev/null | tr -d '\n')
    
    log_info "PAF armateur registration will:"
    log_info "  - Register infrastructure capital contribution"
    log_info "  - Set up PAF payment system"
    log_info "  - Initialize management wallets"
    echo ""
    
    # Check if running in non-interactive mode
    if [ "${NON_INTERACTIVE:-false}" = "true" ]; then
        log_info "Non-interactive mode: Skipping PAF armateur registration (requires user input)"
        return 0
    fi
    
    read -p "Would you like to register PAF armateur now? (y/N): " register_choice
    
    if [[ "$register_choice" =~ ^[Yy]$ ]]; then
        log_info "Running UPLANET.official.sh for infrastructure capital..."
        
        # Run infrastructure capital contribution
        if bash "$official_script" --infrastructure; then
            log_success "PAF armateur registration completed"
        else
            log_warning "PAF armateur registration may have failed"
        fi
    else
        log_info "PAF armateur registration skipped. You can run it later with:"
        log_info "  bash $official_script --infrastructure"
    fi
    
    return 0
}

# Main function
main() {
    log_info "Starting captain setup process..."
    log_info "Astroport.ONE path: $ASTROPORT_PATH"
    echo ""
    
    # Determine UPlanet type
    local uplanet_type=$(determine_uplanet_type)
    log_info "UPlanet type: $uplanet_type"
    echo ""
    
    # Step 1: Setup swarm.key for ẐEN
    if ! setup_swarm_key "$uplanet_type"; then
        log_error "Failed to setup swarm.key"
        if [ "$uplanet_type" = "ZEN" ]; then
            exit 1
        fi
    fi
    echo ""
    
    # Step 2: Retrieve MJ_APIKEY from IPFS
    retrieve_mj_apikey
    echo ""
    
    # Step 3: Create GPS file
    if [ -n "$CAPTAIN_LAT" ] && [ -n "$CAPTAIN_LON" ]; then
        create_gps_file "$CAPTAIN_LAT" "$CAPTAIN_LON"
        echo ""
    fi
    
    # Step 4: Create MULTIPASS
    if [ -n "$CAPTAIN_EMAIL" ]; then
        if ! create_multipass "$CAPTAIN_EMAIL" "$CAPTAIN_LAT" "$CAPTAIN_LON"; then
            log_error "Failed to create MULTIPASS"
            exit 1
        fi
        echo ""
        
        # Step 5: Create ZEN Card
        if ! create_zencard "$CAPTAIN_EMAIL" "$CAPTAIN_LAT" "$CAPTAIN_LON"; then
            log_error "Failed to create ZEN Card"
            exit 1
        fi
        echo ""
    else
        log_warning "CAPTAIN_EMAIL not provided - skipping MULTIPASS and ZEN Card creation"
        log_info "Set CAPTAIN_EMAIL environment variable or pass as argument"
        echo ""
    fi
    
    # Step 6: Create .env file
    create_env_file
    echo ""
    
    # Step 7: Initialize UPlanet wallets
    initialize_uplanet_wallets
    echo ""
    
    # Step 8: Run Y level upgrade (mandatory for ẐEN)
    if ! run_ylevel_upgrade "$uplanet_type"; then
        log_error "Y level upgrade failed"
        if [ "$uplanet_type" = "ZEN" ]; then
            exit 1
        fi
    fi
    echo ""
    
    # Step 9: Configure solar cron for 20h12.process.sh
    configure_solar_cron
    echo ""
    
    # Step 10: Register PAF armateur (optional, requires captain)
    register_paf_armateur
    echo ""
    
    log_success "Captain setup process completed!"
    log_info "Next steps:"
    log_info "  - Review configuration in ${ASTROPORT_PATH}/.env"
    log_info "  - Check cron jobs: crontab -l"
    log_info "  - Monitor 20h12 logs: tail -f /tmp/20h12.log"
    log_info "  - Access captain dashboard: bash ${ASTROPORT_PATH}/captain.sh"
    
    return 0
}

# Run main function
main "$@"
