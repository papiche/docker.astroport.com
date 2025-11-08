#!/bin/bash
# Install strfry NOSTR relay and NIP-101 setup
# This script integrates the logic from install_strfry.sh in a modular, idempotent way

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${SCRIPT_DIR}/install.lib.sh"

# Default workspace directory
WORKSPACE_DIR="${WORKSPACE_DIR:-${HOME}/.zen/workspace}"
NIP101_DIR="${WORKSPACE_DIR}/NIP-101"
STRFRY_SRC_DIR="${WORKSPACE_DIR}/strfry"
STRFRY_INSTALL_DIR="${HOME}/.zen/strfry"

# IPFS binary source information
ipfs_strfry_info() {
    local architecture=$(uname -m)
    log_info "strfry binary IPFS links:"
    local strfry_amd64="/ipfs/QmPq6nbDDXP33n8XG7jJsc5j92xJ7tqsZSeVqkhTYt4V8D"
    local strfry_arm64="/ipfs/Qmb2TNyXhdvaUxec69W7UPQ1yfBAmXpR6TyhXWopzwWi9X"
    if [ "$architecture" == "x86_64" ]; then
        log_info "  AMD64: ipfs get -o $STRFRY_INSTALL_DIR/strfry $strfry_amd64"
    elif [ "$architecture" == "aarch64" ]; then
        log_info "  ARM64: ipfs get -o $STRFRY_INSTALL_DIR/strfry $strfry_arm64"
    fi
}

# Install build dependencies for strfry
install_strfry_dependencies() {
    log_info "Installing strfry build dependencies..."
    
    local deps=(
        "git"
        "g++"
        "make"
        "libssl-dev"
        "zlib1g-dev"
        "liblmdb-dev"
        "libflatbuffers-dev"
        "libsecp256k1-dev"
        "libzstd-dev"
    )
    
    local missing_deps=()
    
    for dep in "${deps[@]}"; do
        if ! dpkg-query -W -f='${Status}' "$dep" 2>/dev/null | grep -q "ok installed"; then
            missing_deps+=("$dep")
        fi
    done
    
    if [ ${#missing_deps[@]} -gt 0 ]; then
        log_info "Installing missing dependencies: ${missing_deps[*]}"
        if sudo apt install -y "${missing_deps[@]}"; then
            log_success "Dependencies installed"
        else
            log_error "Failed to install some dependencies"
            return 1
        fi
    else
        log_success "All dependencies already installed"
    fi
    
    return 0
}

# Clone or update strfry source repository
clone_or_update_strfry() {
    log_info "Cloning/updating strfry source repository..."
    
    if [ -d "$STRFRY_SRC_DIR" ]; then
        if is_git_repo "$STRFRY_SRC_DIR"; then
            log_info "Updating strfry repository..."
            cd "$STRFRY_SRC_DIR"
            git pull || log_warning "Could not pull latest changes"
            cd - >/dev/null
        else
            log_warning "$STRFRY_SRC_DIR exists but is not a git repository"
            return 1
        fi
    else
        log_info "Cloning strfry repository..."
        if git clone https://github.com/hoytech/strfry "$STRFRY_SRC_DIR"; then
            log_success "strfry repository cloned"
        else
            log_error "Failed to clone strfry repository"
            return 1
        fi
    fi
    
    return 0
}

# Compile strfry
compile_strfry() {
    log_info "Compiling strfry..."
    
    if [ ! -d "$STRFRY_SRC_DIR" ]; then
        log_error "strfry source directory not found: $STRFRY_SRC_DIR"
        return 1
    fi
    
    cd "$STRFRY_SRC_DIR"
    
    log_info "Updating git submodules..."
    git submodule update --init || log_warning "Submodule update had issues"
    
    log_info "Running make setup-golpe..."
    make setup-golpe || {
        log_error "make setup-golpe failed"
        cd - >/dev/null
        return 1
    }
    
    log_info "Compiling strfry (this may take a while)..."
    make -j$(nproc) || {
        log_error "strfry compilation failed"
        cd - >/dev/null
        return 1
    }
    
    cd - >/dev/null
    log_success "strfry compiled successfully"
    return 0
}

# Update strfry (if already compiled)
update_strfry() {
    log_info "Updating strfry..."
    
    if [ ! -d "$STRFRY_SRC_DIR" ]; then
        log_error "strfry source directory not found"
        return 1
    fi
    
    cd "$STRFRY_SRC_DIR"
    
    log_info "Updating submodules..."
    make update-submodules || log_warning "Submodule update had issues"
    
    log_info "Recompiling strfry..."
    make -j$(nproc) || {
        log_error "strfry recompilation failed"
        cd - >/dev/null
        return 1
    }
    
    cd - >/dev/null
    log_success "strfry updated"
    return 0
}

# Install strfry binary and configuration
install_strfry_binary() {
    log_info "Installing strfry binary and configuration..."
    
    # Create installation directory
    mkdir -p "$STRFRY_INSTALL_DIR/strfry-db/"
    
    # Check if binary exists in source
    if [ ! -f "$STRFRY_SRC_DIR/strfry" ]; then
        log_error "strfry binary not found in source directory. Please compile first."
        return 1
    fi
    
    # Install binary if it doesn't exist or is different
    if [ ! -f "$STRFRY_INSTALL_DIR/strfry" ] || ! cmp -s "$STRFRY_SRC_DIR/strfry" "$STRFRY_INSTALL_DIR/strfry"; then
        log_info "Installing strfry binary..."
        cp -f "$STRFRY_SRC_DIR/strfry" "$STRFRY_INSTALL_DIR/"
        chmod +x "$STRFRY_INSTALL_DIR/strfry"
        log_success "strfry binary installed"
    else
        log_info "strfry binary unchanged"
    fi
    
    # Copy configuration file if it doesn't exist
    if [ ! -f "$STRFRY_INSTALL_DIR/strfry.conf" ]; then
        if [ -f "$STRFRY_SRC_DIR/strfry.conf" ]; then
            log_info "Creating strfry.conf..."
            sed "s~127.0.0.1~0.0.0.0~g" "$STRFRY_SRC_DIR/strfry.conf" > "$STRFRY_INSTALL_DIR/strfry.conf"
            log_success "strfry.conf created"
        else
            log_warning "strfry.conf template not found in source"
        fi
    else
        log_info "strfry.conf already exists"
    fi
    
    # Copy start script from NIP-101 if available
    if [ -f "$NIP101_DIR/start_strfry-relay.sh" ]; then
        log_info "Copying start script..."
        cp "$NIP101_DIR/start_strfry-relay.sh" "$STRFRY_INSTALL_DIR/start.sh"
        chmod +x "$STRFRY_INSTALL_DIR/start.sh"
        log_success "Start script installed: $STRFRY_INSTALL_DIR/start.sh"
    else
        log_warning "start_strfry-relay.sh not found in NIP-101 directory"
    fi
    
    return 0
}

# Main installation function
install_strfry() {
    log_info "Installing strfry NOSTR relay"
    
    # Show IPFS binary info
    ipfs_strfry_info
    
    # Ensure NIP-101 directory exists (should be cloned in step 2)
    if [ ! -d "$NIP101_DIR" ]; then
        log_warning "NIP-101 directory not found. It should be cloned in step 2."
        log_info "Continuing anyway..."
    fi
    
    # Check if strfry binary already exists
    if [ -f "$STRFRY_INSTALL_DIR/strfry" ] && [ -s "$STRFRY_INSTALL_DIR/strfry" ]; then
        log_info "strfry binary already exists"
        
        # Ask if user wants to update (non-interactive mode: skip update)
        if [ -t 0 ] && [ "${FORCE_UPDATE_STRFRY:-}" != "true" ]; then
            log_info "strfry is already installed. To update, run with FORCE_UPDATE_STRFRY=true"
            log_info "Or manually run: ./install.NEW.sh --only-step 8"
        fi
        
        # If forced or in update mode, recompile
        if [ "${FORCE_UPDATE_STRFRY:-}" = "true" ]; then
            log_info "Force update requested, recompiling..."
            clone_or_update_strfry || return 1
            update_strfry || return 1
            install_strfry_binary || return 1
        else
            # Just ensure configuration is up to date
            install_strfry_binary || return 1
        fi
    else
        # First time installation
        log_info "First time strfry installation"
        
        # Install dependencies
        install_strfry_dependencies || return 1
        
        # Clone repository
        clone_or_update_strfry || return 1
        
        # Compile
        compile_strfry || return 1
        
        # Install binary and config
        install_strfry_binary || return 1
    fi
    
    log_success "strfry installation completed"
    log_info "Strfry binary: $STRFRY_INSTALL_DIR/strfry"
    log_info "Strfry config: $STRFRY_INSTALL_DIR/strfry.conf"
    log_info "Start script: $STRFRY_INSTALL_DIR/start.sh"
    
    if [ -d "$NIP101_DIR" ]; then
        log_info "Next steps:"
        log_info "  1. Setup: $NIP101_DIR/setup.sh"
        log_info "  2. Systemd: $NIP101_DIR/systemd.setup.sh"
    fi
    
    return 0
}

main() {
    check_not_root
    
    # Allow workspace directory to be overridden
    if [ -n "${1:-}" ]; then
        WORKSPACE_DIR="$1"
        NIP101_DIR="${WORKSPACE_DIR}/NIP-101"
        STRFRY_SRC_DIR="${WORKSPACE_DIR}/strfry"
    fi
    
    install_strfry
}

main "$@"

