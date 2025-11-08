#!/bin/bash
# Stop and disable all Astroport.ONE systemd services
# This script is idempotent: it safely handles already stopped services

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${SCRIPT_DIR}/../install.lib.sh"

# List of all Astroport.ONE related services
SERVICES=(
    "astroport"
    "ipfs"
    "g1billet"
    "upassport"
    "strfry"
    "ollama"
    "comfyui"
    "process-stream"
    "ipfs-exporter"
    "nextcloud-exporter"
    "astroport-exporter"
)

stop_services() {
    log_info "Stopping and disabling Astroport.ONE services..."
    
    if ! command_exists systemctl; then
        log_warning "systemctl not available. Skipping service management."
        return 0
    fi
    
    local stopped_count=0
    local disabled_count=0
    
    for service in "${SERVICES[@]}"; do
        # Stop service if active
        if systemctl is-active --quiet "$service" 2>/dev/null; then
            log_info "Stopping $service..."
            if sudo systemctl stop "$service" 2>/dev/null; then
                log_success "$service stopped"
                ((stopped_count++))
            else
                log_warning "Failed to stop $service"
            fi
        fi
        
        # Disable service if enabled
        if systemctl is-enabled --quiet "$service" 2>/dev/null; then
            log_info "Disabling $service..."
            if sudo systemctl disable "$service" 2>/dev/null; then
                log_success "$service disabled"
                ((disabled_count++))
            else
                log_warning "Failed to disable $service"
            fi
        fi
    done
    
    # Kill any remaining processes
    log_info "Killing remaining processes..."
    
    if [ -f ~/.zen/.pid ]; then
        local pid=$(cat ~/.zen/.pid 2>/dev/null)
        if [ -n "$pid" ] && kill -0 "$pid" 2>/dev/null; then
            log_info "Killing process $pid from ~/.zen/.pid"
            kill -9 "$pid" 2>/dev/null || true
        fi
    fi
    
    # Kill processes by pattern
    pkill -f "20h12.process.sh" 2>/dev/null || true
    pkill -f "python.*54321.py" 2>/dev/null || true
    pkill -f "strfry" 2>/dev/null || true
    pkill -f "12345.sh" 2>/dev/null || true
    pkill -f "_12345.sh" 2>/dev/null || true
    pkill -f "G1BILLETS.sh" 2>/dev/null || true
    pkill -f "ipfs daemon" 2>/dev/null || true
    
    log_success "Services stopped ($stopped_count) and disabled ($disabled_count)"
    return 0
}

main() {
    check_not_root
    stop_services
}

main "$@"

