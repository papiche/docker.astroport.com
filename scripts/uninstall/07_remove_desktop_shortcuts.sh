#!/bin/bash
# Remove desktop shortcuts
# This script is idempotent: it safely handles missing files

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${SCRIPT_DIR}/../install.lib.sh"

# Desktop shortcut files
SHORTCUTS=(
    "~/Bureau/astroport.desktop"
    "~/Desktop/astroport.desktop"
    "~/Bureau/rec.desktop"
    "~/Desktop/rec.desktop"
    "~/Bureau/g1billet.desktop"
    "~/Desktop/g1billet.desktop"
)

remove_desktop_shortcuts() {
    log_info "Removing desktop shortcuts..."
    
    local removed_count=0
    
    for shortcut in "${SHORTCUTS[@]}"; do
        # Expand ~ to home directory
        local expanded_shortcut="${shortcut/#\~/$HOME}"
        if [ -f "$expanded_shortcut" ]; then
            log_info "Removing $expanded_shortcut..."
            if rm -f "$expanded_shortcut"; then
                log_success "Removed $expanded_shortcut"
                ((removed_count++))
            fi
        fi
    done
    
    if [ $removed_count -gt 0 ]; then
        log_success "Desktop shortcuts removed ($removed_count files)"
    else
        log_info "No desktop shortcuts to remove"
    fi
    
    return 0
}

main() {
    check_not_root
    remove_desktop_shortcuts
}

main "$@"

