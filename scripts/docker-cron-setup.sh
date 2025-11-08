#!/bin/bash
# Docker cron setup script
# Configures cron for 20h12.process.sh in Docker container
# Uses fixed time (20:12) instead of solar time calculation

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${SCRIPT_DIR}/install.lib.sh" 2>/dev/null || true

# Default to 20:12 (fixed time for Docker)
CRON_HOUR="${CRON_HOUR:-20}"
CRON_MINUTE="${CRON_MINUTE:-12}"

setup_cron() {
    log_info "Setting up cron for 20h12.process.sh (Docker mode)"
    
    # Find 20h12.process.sh script
    local process_script=""
    if [ -f "${HOME}/.zen/Astroport.ONE/20h12.process.sh" ]; then
        process_script="${HOME}/.zen/Astroport.ONE/20h12.process.sh"
    elif [ -f "${HOME}/.zen/workspace/Astroport.ONE/20h12.process.sh" ]; then
        process_script="${HOME}/.zen/workspace/Astroport.ONE/20h12.process.sh"
    fi
    
    if [ -z "$process_script" ]; then
        log_warning "20h12.process.sh not found - skipping cron setup"
        return 0
    fi
    
    # Make script executable
    chmod +x "$process_script" 2>/dev/null || true
    
    # Create cron entry (fixed time for Docker)
    local cron_entry="${CRON_MINUTE} ${CRON_HOUR} * * * /bin/bash ${process_script} >> /tmp/20h12.log 2>&1"
    
    # Get current crontab or create empty one
    local temp_cron=$(mktemp)
    crontab -l > "$temp_cron" 2>/dev/null || touch "$temp_cron"
    
    # Remove existing 20h12.process.sh entries
    if grep -q "20h12.process.sh" "$temp_cron" 2>/dev/null; then
        log_info "Removing existing 20h12.process.sh cron entry..."
        grep -v "20h12.process.sh" "$temp_cron" > "${temp_cron}.new" || touch "${temp_cron}.new"
        mv "${temp_cron}.new" "$temp_cron"
    fi
    
    # Add new cron entry
    echo "$cron_entry" >> "$temp_cron"
    crontab "$temp_cron"
    rm -f "$temp_cron"
    
    log_success "Cron configured: ${CRON_MINUTE} ${CRON_HOUR} * * * (20h12.process.sh)"
    log_info "Cron will run daily at ${CRON_HOUR}:${CRON_MINUTE}"
    
    return 0
}

main() {
    setup_cron
}

main "$@"

