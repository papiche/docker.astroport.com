#!/bin/bash
# Remove custom sudoers files
# This script is idempotent: it safely handles missing files

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${SCRIPT_DIR}/../install.lib.sh"

# List of sudoers files to remove
SUDOERS_FILES=(
    "/etc/sudoers.d/astroport"
    "/etc/sudoers.d/fail2ban-client"
    "/etc/sudoers.d/mount"
    "/etc/sudoers.d/umount"
    "/etc/sudoers.d/apt-get"
    "/etc/sudoers.d/apt"
    "/etc/sudoers.d/systemctl"
    "/etc/sudoers.d/docker"
    "/etc/sudoers.d/hdparm"
    "/etc/sudoers.d/brother_ql_print"
)

remove_sudoers() {
    log_info "Removing custom sudoers files..."
    
    local removed_count=0
    
    for sudoers_file in "${SUDOERS_FILES[@]}"; do
        # Special case for astroport (only for xbian user)
        if [[ "$sudoers_file" == "/etc/sudoers.d/astroport" ]] && [[ "$USER" != "xbian" ]]; then
            continue
        fi
        
        if [ -f "$sudoers_file" ]; then
            log_info "Removing $sudoers_file..."
            if sudo rm -f "$sudoers_file"; then
                log_success "Removed $sudoers_file"
                ((removed_count++))
            else
                log_warning "Failed to remove $sudoers_file"
            fi
        fi
    done
    
    if [ $removed_count -gt 0 ]; then
        log_success "Sudoers files removed ($removed_count files)"
    else
        log_info "No sudoers files to remove"
    fi
    
    return 0
}

main() {
    check_not_root
    remove_sudoers
}

main "$@"

