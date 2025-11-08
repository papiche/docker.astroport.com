#!/bin/bash
# Process 20h12 installation complement
# This script handles the setup.sh equivalent steps for Docker installation
# It performs post-installation configuration that setup.sh normally does

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${SCRIPT_DIR}/install.lib.sh"

# Default workspace directory
WORKSPACE_DIR="${WORKSPACE_DIR:-${HOME}/.zen/workspace}"
ASTROPORT_DIR="${HOME}/.zen/Astroport.ONE"

process_20h12() {
    log_info "Running 20h12 installation complement (setup.sh equivalent)"
    
    # 1. Initialize IPFS if needed
    if command_exists ipfs; then
        log_info "Checking IPFS initialization..."
        if [ ! -d "${HOME}/.ipfs" ]; then
            log_info "Initializing IPFS..."
            ipfs init || log_warning "IPFS initialization failed or already initialized"
        fi
        
        # Setup IPFS API endpoint
        if [ -f "${HOME}/.ipfs/api" ]; then
            echo "/ip4/127.0.0.1/tcp/5001" > "${HOME}/.ipfs/api"
            log_success "IPFS API endpoint configured"
        fi
    fi
    
    # 2. Setup .zen directory structure
    local zen_dir="${HOME}/.zen"
    if [ ! -d "$zen_dir" ]; then
        log_info "Creating .zen directory structure..."
        mkdir -p "$zen_dir"/{tmp,logs,config,game,workspace}
        mkdir -p "$zen_dir/tmp"/{swarm,coucou,flashmem}
    fi
    
    # 3. Setup bashrc if Astroport.ONE is available
    if [ -d "$ASTROPORT_DIR" ] && [ -f "${ASTROPORT_DIR}/tools/my.sh" ]; then
        log_info "Configuring bashrc with Astroport.ONE paths..."
        
        # Add PATH extensions
        if ! grep -q "export PATH=\$HOME/.local/bin:/usr/games:\$PATH" "${HOME}/.bashrc" 2>/dev/null; then
            echo "" >> "${HOME}/.bashrc"
            echo "# Astroport.ONE PATH extensions" >> "${HOME}/.bashrc"
            echo "export PATH=\$HOME/.local/bin:/usr/games:\$PATH" >> "${HOME}/.bashrc"
        fi
        
        # Add Python virtual environment activation
        if [ -f "${HOME}/.astro/bin/activate" ]; then
            if ! grep -q ". \$HOME/.astro/bin/activate" "${HOME}/.bashrc" 2>/dev/null; then
                echo ". \$HOME/.astro/bin/activate" >> "${HOME}/.bashrc"
            fi
        fi
        
        # Add my.sh source
        if ! grep -q ". \$HOME/.zen/Astroport.ONE/tools/my.sh" "${HOME}/.bashrc" 2>/dev/null; then
            echo ". \$HOME/.zen/Astroport.ONE/tools/my.sh" >> "${HOME}/.bashrc"
        fi
        
        log_success "bashrc configured"
    fi
    
    # 4. Create symlinks for tools (equivalent to setup.sh)
    if [ -d "$ASTROPORT_DIR" ]; then
        log_info "Creating tool symlinks..."
        mkdir -p "${HOME}/.local/bin"
        
        # Link keygen
        if [ -f "${ASTROPORT_DIR}/tools/keygen" ]; then
            ln -sf "${ASTROPORT_DIR}/tools/keygen" "${HOME}/.local/bin/keygen" 2>/dev/null || true
        fi
        
        # Link jaklis
        if [ -f "${ASTROPORT_DIR}/tools/jaklis/jaklis.py" ]; then
            ln -sf "${ASTROPORT_DIR}/tools/jaklis/jaklis.py" "${HOME}/.local/bin/jaklis" 2>/dev/null || true
        fi
        
        # Link natools
        if [ -f "${ASTROPORT_DIR}/tools/natools.py" ]; then
            ln -sf "${ASTROPORT_DIR}/tools/natools.py" "${HOME}/.local/bin/natools" 2>/dev/null || true
        fi
        
        log_success "Tool symlinks created"
    fi
    
    # 5. Verify NIP-101 and backfill_constellation.sh availability
    if [ -d "${WORKSPACE_DIR}/NIP-101" ]; then
        if [ -f "${WORKSPACE_DIR}/NIP-101/backfill_constellation.sh" ]; then
            log_success "backfill_constellation.sh found in workspace"
            chmod +x "${WORKSPACE_DIR}/NIP-101/backfill_constellation.sh" 2>/dev/null || true
        else
            log_warning "backfill_constellation.sh not found in NIP-101 directory"
        fi
    else
        log_warning "NIP-101 directory not found - constellation sync may not work"
    fi
    
    # 6. Post-installation verification
    log_info "Verifying installation..."
    local verification_passed=true
    
    # Check if key directories exist
    for dir in "$WORKSPACE_DIR/UPassport" "$WORKSPACE_DIR/UPlanet" "$WORKSPACE_DIR/Astroport.ONE"; do
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
    
    log_info "20h12 process completed"
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

