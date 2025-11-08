#!/bin/bash
# Process 20h12 installation complement
# This script handles the additional installation steps that were previously in 20h12.process.sh

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${SCRIPT_DIR}/install.lib.sh"

# Default workspace directory
WORKSPACE_DIR="${WORKSPACE_DIR:-${HOME}/.zen/workspace}"

process_20h12() {
    log_info "Running 20h12 installation complement"
    
    # This is a placeholder for the 20h12.process.sh logic
    # You should integrate the actual content from 20h12.process.sh here
    
    # Example steps that might be in 20h12.process.sh:
    # - Additional configuration
    # - Post-installation setup
    # - Service initialization
    # - Data migration
    # - Cache clearing
    
    log_info "Checking for additional installation steps..."
    
    # Check if there's a legacy 20h12.process.sh script to source
    local legacy_script="${SCRIPT_DIR}/../20h12.process.sh"
    if [ -f "$legacy_script" ]; then
        log_info "Found legacy 20h12.process.sh. Executing..."
        if bash "$legacy_script"; then
            log_success "Legacy 20h12.process.sh completed"
        else
            log_error "Legacy 20h12.process.sh failed"
            return 1
        fi
    else
        log_info "No legacy 20h12.process.sh found. Running default 20h12 steps..."
        
        # Default 20h12 steps
        # 1. Initialize IPFS if needed
        if command_exists ipfs; then
            log_info "Checking IPFS initialization..."
            if [ ! -d "${HOME}/.ipfs" ]; then
                log_info "Initializing IPFS..."
                ipfs init || log_warning "IPFS initialization failed or already initialized"
            fi
        fi
        
        # 2. Setup additional symlinks or directories
        local zen_dir="${HOME}/.zen"
        if [ ! -d "$zen_dir" ]; then
            log_info "Creating .zen directory structure..."
            mkdir -p "$zen_dir"/{tmp,logs,config}
        fi
        
        # 3. Post-installation verification
        log_info "Verifying installation..."
        local verification_passed=true
        
        # Check if key directories exist
        for dir in "$WORKSPACE_DIR/UPassport" "$WORKSPACE_DIR/UPlanet"; do
            if [ ! -d "$dir" ]; then
                log_warning "Directory not found: $dir"
                verification_passed=false
            fi
        done
        
        if [ "$verification_passed" = true ]; then
            log_success "Installation verification passed"
        else
            log_warning "Some verification checks failed"
        fi
        
        # 4. Additional setup steps can be added here
        log_info "20h12 process completed"
    fi
    
    return 0
}

main() {
    check_not_root
    
    # Allow workspace directory to be overridden
    if [ -n "${1:-}" ]; then
        WORKSPACE_DIR="$1"
    fi
    
    process_20h12
}

main "$@"

