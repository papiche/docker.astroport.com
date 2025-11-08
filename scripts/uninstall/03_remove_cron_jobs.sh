#!/bin/bash
# Remove cron jobs related to Astroport.ONE
# This script is idempotent: it safely handles missing cron jobs

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${SCRIPT_DIR}/../install.lib.sh"

# Patterns to remove from crontab
CRON_PATTERNS=(
    "20h12.process.sh"
    "cron_MINUTE"
    "ipfs repo gc"
    "ASTROPORT"
    "Astroport"
)

remove_cron_jobs() {
    log_info "Removing Astroport.ONE cron jobs..."
    
    # Get current crontab or create empty one
    local temp_cron=$(mktemp)
    crontab -l > "$temp_cron" 2>/dev/null || touch "$temp_cron"
    
    local original_lines=$(wc -l < "$temp_cron")
    local temp_cron_filtered=$(mktemp)
    
    # Remove lines containing any of the patterns
    cp "$temp_cron" "$temp_cron_filtered"
    for pattern in "${CRON_PATTERNS[@]}"; do
        grep -v "$pattern" "$temp_cron_filtered" > "${temp_cron_filtered}.new" || true
        mv "${temp_cron_filtered}.new" "$temp_cron_filtered"
    done
    
    local filtered_lines=$(wc -l < "$temp_cron_filtered")
    local removed_count=$((original_lines - filtered_lines))
    
    if [ $removed_count -gt 0 ]; then
        log_info "Removing $removed_count cron job(s)..."
        crontab "$temp_cron_filtered"
        log_success "Cron jobs removed"
    else
        log_info "No Astroport.ONE cron jobs found"
    fi
    
    rm -f "$temp_cron" "$temp_cron_filtered"
    
    return 0
}

main() {
    check_not_root
    remove_cron_jobs
}

main "$@"

