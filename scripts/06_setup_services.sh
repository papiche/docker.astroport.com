#!/bin/bash
# Setup systemd services for UPlanet components
# This script is idempotent: it will update existing services

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${SCRIPT_DIR}/install.lib.sh"

# Default workspace directory
WORKSPACE_DIR="${WORKSPACE_DIR:-${HOME}/.zen/workspace}"
TEMPLATES_DIR="${TEMPLATES_DIR:-${SCRIPT_DIR}/../templates}"

setup_services() {
    log_info "Setting up systemd services"
    
    check_not_root
    
    # Check if systemctl is available
    if ! command_exists systemctl; then
        log_warning "systemctl not available. Skipping service setup."
        return 0
    fi
    
    # Check if we can use sudo
    if ! sudo -n true 2>/dev/null; then
        log_warning "sudo access required for systemd service setup"
        log_info "You may need to run this script with appropriate sudo permissions"
    fi
    
    local failed_services=()
    local python_path=$(which python3)
    local astroport_dir="${HOME}/.zen/Astroport.ONE"
    local upassport_dir="${HOME}/.zen/UPassport"
    local g1billet_dir="${HOME}/.zen/G1BILLET"
    local strfry_dir="${HOME}/.zen/strfry"
    
    # Setup Astroport service (12345.sh)
    if [ -f "${astroport_dir}/12345.sh" ]; then
        log_info "Setting up Astroport service..."
        local service_file="/tmp/astroport.service"
        
        if [ -f "${TEMPLATES_DIR}/astroport.service.tpl" ]; then
            cat "${TEMPLATES_DIR}/astroport.service.tpl" \
                | sed "s|__USER__|${USER}|g" \
                | sed "s|__ASTROPORT_PATH__|${astroport_dir}|g" \
                | sed "s|__HOME_DIR__|${HOME}|g" > "$service_file"
        else
            # Create service file directly if template doesn't exist
            cat > "$service_file" <<EOF
[Unit]
Description=ASTROPORT API
After=network.target
Requires=network.target

[Service]
Type=simple
User=${USER}
RestartSec=1
Restart=always
ExecStart=${astroport_dir}/12345.sh
StandardOutput=file:${HOME}/.zen/tmp/12345.log

[Install]
WantedBy=multi-user.target
EOF
        fi
        
        if sudo cp "$service_file" /etc/systemd/system/astroport.service; then
            sudo systemctl daemon-reload
            sudo systemctl enable astroport.service
            log_success "Astroport service configured"
        else
            log_error "Failed to setup Astroport service"
            failed_services+=("astroport")
        fi
    else
        log_warning "Astroport 12345.sh not found. Skipping..."
    fi
    
    # Setup IPFS service
    if command_exists ipfs; then
        log_info "Setting up IPFS service..."
        local service_file="/tmp/ipfs.service"
        
        if [ -f "${TEMPLATES_DIR}/ipfs.service.tpl" ]; then
            cat "${TEMPLATES_DIR}/ipfs.service.tpl" \
                | sed "s|__USER__|${USER}|g" > "$service_file"
        else
            cat > "$service_file" <<EOF
[Unit]
Description=IPFS daemon
After=network.target

[Service]
User=${USER}
ExecStart=/usr/local/bin/ipfs daemon --enable-pubsub-experiment --enable-namesys-pubsub
Restart=on-failure
CPUAccounting=true
CPUQuota=60%

[Install]
WantedBy=multi-user.target
EOF
        fi
        
        if sudo cp "$service_file" /etc/systemd/system/ipfs.service; then
            sudo systemctl daemon-reload
            sudo systemctl enable ipfs.service
            log_success "IPFS service configured"
        else
            log_error "Failed to setup IPFS service"
            failed_services+=("ipfs")
        fi
    else
        log_warning "IPFS not found. Skipping IPFS service..."
    fi
    
    # Setup UPassport service
    if [ -f "${upassport_dir}/54321.py" ]; then
        log_info "Setting up UPassport service..."
        local service_file="/tmp/upassport.service"
        
        if [ -f "${upassport_dir}/upassport.service.tpl" ]; then
            cat "${upassport_dir}/upassport.service.tpl" \
                | sed "s|_USER_|${USER}|g" \
                | sed "s|_PYTHON_|${python_path}|g" \
                | sed "s|_MY_PATH_|${upassport_dir}|g" > "$service_file"
        else
            cat > "$service_file" <<EOF
[Unit]
Description=UPasport - UPlanet 54321 - Service
After=network.target

[Service]
User=${USER}
Group=${USER}
Environment="PATH=%h/.local/bin:%h/.astro/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin"
WorkingDirectory=${upassport_dir}
ExecStart=${python_path} ${upassport_dir}/54321.py
Restart=always

[Install]
WantedBy=multi-user.target
EOF
        fi
        
        if sudo cp "$service_file" /etc/systemd/system/upassport.service; then
            sudo systemctl daemon-reload
            sudo systemctl enable upassport.service
            log_success "UPassport service configured"
        else
            log_error "Failed to setup UPassport service"
            failed_services+=("upassport")
        fi
    else
        log_warning "UPassport 54321.py not found. Skipping..."
    fi
    
    # Setup G1BILLET service
    if [ -f "${g1billet_dir}/G1BILLETS.sh" ]; then
        log_info "Setting up G1BILLET service..."
        local service_file="/tmp/g1billet.service"
        
        if [ -f "${TEMPLATES_DIR}/g1billet.service.tpl" ]; then
            cat "${TEMPLATES_DIR}/g1billet.service.tpl" \
                | sed "s|__USER__|${USER}|g" \
                | sed "s|__G1BILLET_PATH__|${g1billet_dir}|g" \
                | sed "s|__HOME_DIR__|${HOME}|g" > "$service_file"
        else
            cat > "$service_file" <<EOF
[Unit]
Description=G1BILLET API
After=network.target
Requires=network.target

[Service]
Type=simple
User=${USER}
RestartSec=1
Restart=always
ExecStart=${g1billet_dir}/G1BILLETS.sh daemon
StandardOutput=file:${HOME}/.zen/tmp/g1billet.log

[Install]
WantedBy=multi-user.target
EOF
        fi
        
        if sudo cp "$service_file" /etc/systemd/system/g1billet.service; then
            sudo systemctl daemon-reload
            sudo systemctl enable g1billet.service
            log_success "G1BILLET service configured"
        else
            log_error "Failed to setup G1BILLET service"
            failed_services+=("g1billet")
        fi
    else
        log_warning "G1BILLET G1BILLETS.sh not found. Skipping..."
    fi
    
    # Setup Strfry service
    if [ -f "${strfry_dir}/start.sh" ]; then
        log_info "Setting up Strfry service..."
        local service_file="/tmp/strfry.service"
        
        if [ -f "${TEMPLATES_DIR}/strfry.service.tpl" ]; then
            cat "${TEMPLATES_DIR}/strfry.service.tpl" \
                | sed "s|__USER__|${USER}|g" \
                | sed "s|__STRFRY_PATH__|${strfry_dir}|g" > "$service_file"
        else
            cat > "$service_file" <<EOF
[Unit]
Description=NOSTR strfry relay service
After=network.target
Requires=network.target

[Service]
Type=forking
User=${USER}
Restart=always
WorkingDirectory=${strfry_dir}
ExecStart=${strfry_dir}/start.sh
PIDFile=${strfry_dir}/.pid
LimitNOFILE=1000000

[Install]
WantedBy=multi-user.target
EOF
        fi
        
        if sudo cp "$service_file" /etc/systemd/system/strfry.service; then
            sudo systemctl daemon-reload
            sudo systemctl enable strfry.service
            log_success "Strfry service configured"
        else
            log_error "Failed to setup Strfry service"
            failed_services+=("strfry")
        fi
    else
        log_warning "Strfry start.sh not found. Skipping..."
    fi
    
    if [ ${#failed_services[@]} -gt 0 ]; then
        log_error "Failed to setup services: ${failed_services[*]}"
        return 1
    fi
    
    log_success "All systemd services are configured"
    return 0
}

main() {
    # Allow workspace directory to be overridden
    if [ -n "${1:-}" ]; then
        WORKSPACE_DIR="$1"
    fi
    
    setup_services
}

main "$@"

