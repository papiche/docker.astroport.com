#!/bin/bash
# Clean bashrc from Astroport.ONE modifications
# This script is idempotent: it safely handles missing backups

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${SCRIPT_DIR}/../install.lib.sh"

# Patterns to remove from bashrc
BASHRC_PATTERNS=(
    "ASTROPORT"
    "astro/bin/activate"
    "\\.zen/Astroport\\.ONE"
    "IPFSNODEID"
    "UPLANET"
    "CAPTAIN"
    "cowsay.*hostname"
)

clean_bashrc() {
    log_info "Cleaning bashrc from Astroport.ONE modifications..."
    
    local bashrc_file="${HOME}/.bashrc"
    
    if [ ! -f "$bashrc_file" ]; then
        log_warning "bashrc file not found: $bashrc_file"
        return 0
    fi
    
    # Restore from backup if available
    if [ -f "${bashrc_file}.bak" ]; then
        log_info "Restoring bashrc from backup..."
        if cp "${bashrc_file}.bak" "$bashrc_file"; then
            log_success "bashrc restored from backup"
            return 0
        else
            log_warning "Failed to restore from backup, cleaning manually..."
        fi
    fi
    
    # Manual cleaning
    log_info "Cleaning bashrc manually..."
    local cleaned=false
    
    for pattern in "${BASHRC_PATTERNS[@]}"; do
        if grep -q "$pattern" "$bashrc_file" 2>/dev/null; then
            sed -i "/$pattern/d" "$bashrc_file"
            cleaned=true
        fi
    done
    
    if [ "$cleaned" = true ]; then
        log_success "bashrc cleaned"
    else
        log_info "No Astroport.ONE modifications found in bashrc"
    fi
    
    return 0
}

main() {
    check_not_root
    clean_bashrc
}

main "$@"

