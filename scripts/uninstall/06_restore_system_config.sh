#!/bin/bash
# Restore system configuration files
# This script is idempotent: it safely handles missing backups

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${SCRIPT_DIR}/../install.lib.sh"

restore_system_config() {
    log_info "Restoring system configuration files..."
    
    local restored_count=0
    
    # Disable IPFS (for xbian user)
    if [[ "$USER" == "xbian" ]]; then
        log_info "Disabling IPFS init scripts..."
        for runlevel in rc2.d rc3.d rc4.d rc5.d; do
            if [ -f "/etc/${runlevel}/S02ipfs" ]; then
                sudo mv "/etc/${runlevel}/S02ipfs" "/etc/${runlevel}/K01ipfs" 2>/dev/null && ((restored_count++)) || true
            fi
        done
    fi
    
    # Restore KODI
    if [ -e ~/.kodi.old ]; then
        log_info "Restoring KODI..."
        rm -rf ~/.kodi 2>/dev/null || true
        mv ~/.kodi.old ~/.kodi 2>/dev/null && ((restored_count++)) || true
    fi
    
    # Restore resolv.conf
    if [ -s /etc/resolv.conf.backup ]; then
        log_info "Restoring resolv.conf..."
        sudo chattr -i /etc/resolv.conf 2>/dev/null || true
        sudo cp /etc/resolv.conf.backup /etc/resolv.conf 2>/dev/null && ((restored_count++)) || true
    fi
    
    # Restore SSH config
    if [ -s /etc/ssh/sshd_config.bak ]; then
        log_info "Restoring SSH config..."
        sudo cp /etc/ssh/sshd_config.bak /etc/ssh/sshd_config 2>/dev/null && ((restored_count++)) || true
        sudo systemctl restart ssh 2>/dev/null || true
    fi
    
    # Remove custom hosts entries
    if grep -q "astroport.local" /etc/hosts 2>/dev/null || grep -q "duniter.localhost" /etc/hosts 2>/dev/null; then
        log_info "Removing custom hosts entries..."
        sudo sed -i '/astroport\.local/d' /etc/hosts 2>/dev/null || true
        sudo sed -i '/duniter\.localhost/d' /etc/hosts 2>/dev/null || true
        ((restored_count++))
    fi
    
    # Restore ImageMagick policy
    if [ -f /etc/ImageMagick-6/policy.xml.backup ]; then
        log_info "Restoring ImageMagick policy..."
        sudo cp /etc/ImageMagick-6/policy.xml.backup /etc/ImageMagick-6/policy.xml 2>/dev/null && ((restored_count++)) || true
    fi
    
    if [ $restored_count -gt 0 ]; then
        log_success "System configuration restored ($restored_count items)"
    else
        log_info "No system configuration to restore"
    fi
    
    return 0
}

main() {
    check_not_root
    restore_system_config
}

main "$@"

