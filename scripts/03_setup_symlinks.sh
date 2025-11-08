#!/bin/bash
# Setup symbolic links for easy access
# This script is idempotent: it will update existing symlinks if needed

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${SCRIPT_DIR}/install.lib.sh"

# Default workspace directory
WORKSPACE_DIR="${WORKSPACE_DIR:-${HOME}/.zen/workspace}"

# Symlink configuration: target, link_path
# Format: "target_path|link_path"
# Note: UPlanet stays in workspace, no symlink needed
SYMLINKS=(
    "${WORKSPACE_DIR}/UPassport|${HOME}/.zen/UPassport"
    "${WORKSPACE_DIR}/Astroport.ONE|${HOME}/.zen/Astroport.ONE"
    "${WORKSPACE_DIR}/G1BILLET|${HOME}/.zen/G1BILLET"
)

setup_symlinks() {
    log_info "Setting up symbolic links"
    
    local failed_links=()
    
    for link_config in "${SYMLINKS[@]}"; do
        IFS='|' read -r target_path link_path <<< "$link_config"
        
        # Resolve target path
        local resolved_target=$(readlink -f "$target_path" 2>/dev/null || echo "$target_path")
        
        if [ ! -e "$resolved_target" ]; then
            log_warning "Target does not exist: $resolved_target. Skipping symlink creation."
            continue
        fi
        
        log_info "Creating symlink: $link_path -> $resolved_target"
        
        if create_symlink "$resolved_target" "$link_path"; then
            log_success "Symlink created: $link_path"
        else
            log_error "Failed to create symlink: $link_path"
            failed_links+=("$link_path")
        fi
    done
    
    if [ ${#failed_links[@]} -gt 0 ]; then
        log_error "Failed to create symlinks: ${failed_links[*]}"
        return 1
    fi
    
    log_success "All symlinks are set up"
    return 0
}

main() {
    check_not_root
    
    # Allow workspace directory to be overridden
    if [ -n "${1:-}" ]; then
        WORKSPACE_DIR="$1"
    fi
    
    setup_symlinks
}

main "$@"

