#!/bin/bash
# Final cleanup: mark directories for deletion and clean temp files
# This script is idempotent: it safely handles already processed directories

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${SCRIPT_DIR}/../install.lib.sh"

cleanup_directories() {
    log_info "Performing final cleanup..."
    
    # Mark .zen directory for deletion
    if [ -d ~/.zen ] && [ ! -d ~/.zen.todelete ]; then
        log_info "Marking ~/.zen for deletion..."
        if mv ~/.zen ~/.zen.todelete 2>/dev/null; then
            log_success "~/.zen renamed to ~/.zen.todelete"
            log_warning "Manual cleanup required: rm -rf ~/.zen.todelete"
        else
            log_warning "Failed to rename ~/.zen (may be in use)"
        fi
    elif [ -d ~/.zen.todelete ]; then
        log_info "~/.zen.todelete already exists"
    fi
    
    # Clean temporary files
    log_info "Cleaning temporary files..."
    local temp_patterns=(
        "/tmp/20h12.log"
        "/tmp/astroport.*"
        "/tmp/ipfs.*"
        "/tmp/strfry.*"
        "/tmp/g1billet.*"
        "/tmp/upassport.*"
    )
    
    local cleaned_count=0
    for pattern in "${temp_patterns[@]}"; do
        # Use find for patterns with wildcards
        if [[ "$pattern" == *"*"* ]]; then
            find /tmp -maxdepth 1 -name "$(basename "$pattern")" -type f -delete 2>/dev/null && ((cleaned_count++)) || true
        elif [ -e "$pattern" ]; then
            rm -f "$pattern" 2>/dev/null && ((cleaned_count++)) || true
        fi
    done
    
    if [ $cleaned_count -gt 0 ]; then
        log_success "Temporary files cleaned ($cleaned_count patterns)"
    else
        log_info "No temporary files to clean"
    fi
    
    return 0
}

main() {
    check_not_root
    cleanup_directories
}

main "$@"

