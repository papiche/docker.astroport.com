#!/bin/bash
# Remove local binaries and symlinks
# This script is idempotent: it safely handles missing files

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${SCRIPT_DIR}/../install.lib.sh"

# List of binaries to remove from ~/.local/bin
BINARIES=(
    "natools"
    "jaklis"
    "keygen"
    "coeurbox"
    "youtube-dl"
    "yt-dlp"
    "lazydocker"
    "silkaj"
    "espeak"
)

remove_binaries() {
    log_info "Removing local binaries and symlinks..."
    
    local bin_dir="${HOME}/.local/bin"
    local removed_count=0
    
    if [ ! -d "$bin_dir" ]; then
        log_info "Binary directory does not exist: $bin_dir"
        return 0
    fi
    
    for binary in "${BINARIES[@]}"; do
        local binary_path="${bin_dir}/${binary}"
        if [ -e "$binary_path" ]; then
            log_info "Removing $binary_path..."
            if rm -f "$binary_path"; then
                log_success "Removed $binary_path"
                ((removed_count++))
            else
                log_warning "Failed to remove $binary_path"
            fi
        fi
    done
    
    if [ $removed_count -gt 0 ]; then
        log_success "Binaries removed ($removed_count files)"
    else
        log_info "No binaries to remove"
    fi
    
    return 0
}

main() {
    check_not_root
    remove_binaries
}

main "$@"

