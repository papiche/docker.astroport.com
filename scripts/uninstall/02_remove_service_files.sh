#!/bin/bash
# Remove systemd service files
# This script is idempotent: it safely handles missing files

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${SCRIPT_DIR}/../install.lib.sh"

# List of systemd service files to remove
SERVICE_FILES=(
    "/etc/systemd/system/astroport.service"
    "/etc/systemd/system/ipfs.service"
    "/etc/systemd/system/g1billet.service"
    "/etc/systemd/system/upassport.service"
    "/etc/systemd/system/strfry.service"
    "/etc/systemd/system/process-stream.service"
    "/etc/systemd/system/ipfs-exporter.service"
    "/etc/systemd/system/nextcloud-exporter.service"
    "/etc/systemd/system/astroport-exporter.service"
    "/etc/systemd/system/comfyui.service"
)

remove_service_files() {
    log_info "Removing systemd service files..."
    
    local removed_count=0
    
    for service_file in "${SERVICE_FILES[@]}"; do
        if [ -f "$service_file" ]; then
            log_info "Removing $service_file..."
            if sudo rm -f "$service_file"; then
                log_success "Removed $service_file"
                ((removed_count++))
            else
                log_warning "Failed to remove $service_file"
            fi
        fi
    done
    
    # Reload systemd daemon
    if [ $removed_count -gt 0 ]; then
        log_info "Reloading systemd daemon..."
        sudo systemctl daemon-reload
        log_success "Systemd daemon reloaded"
    else
        log_info "No service files to remove"
    fi
    
    log_success "Service files removal completed ($removed_count files removed)"
    return 0
}

main() {
    check_not_root
    remove_service_files
}

main "$@"

