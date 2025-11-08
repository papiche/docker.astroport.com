#!/bin/bash
# Configure system using template-based configuration files
# This script uses templates and sed for substitution (following user preference)

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${SCRIPT_DIR}/install.lib.sh"

# Default workspace directory
WORKSPACE_DIR="${WORKSPACE_DIR:-${HOME}/.zen/workspace}"
TEMPLATES_DIR="${TEMPLATES_DIR:-${SCRIPT_DIR}/../templates}"

# Configuration values (can be overridden by environment or whiptail)
TW_PORT="${TW_PORT:-54323}"
TW_HOST="${TW_HOST:-0.0.0.0}"

configure_system() {
    log_info "Configuring system using templates"
    
    # Create templates directory if it doesn't exist
    if [ ! -d "$TEMPLATES_DIR" ]; then
        log_warning "Templates directory not found: $TEMPLATES_DIR"
        log_info "Creating basic templates..."
        mkdir -p "$TEMPLATES_DIR"
    fi
    
    # Interactive configuration if whiptail is available
    if command_exists whiptail; then
        log_info "Interactive configuration available"
        
        # Get TW_PORT
        local port_input=$(whiptail --inputbox "Enter TW_PORT (default: 54323):" 8 40 "$TW_PORT" 3>&1 1>&2 2>&3)
        if [ -n "$port_input" ]; then
            TW_PORT="$port_input"
        fi
        
        # Get TW_HOST
        local host_input=$(whiptail --inputbox "Enter TW_HOST (default: 0.0.0.0):" 8 40 "$TW_HOST" 3>&1 1>&2 2>&3)
        if [ -n "$host_input" ]; then
            TW_HOST="$host_input"
        fi
    else
        log_info "Using default/environment configuration values"
    fi
    
    # Process configuration templates
    local config_files=()
    
    # Find all template files
    if [ -d "$TEMPLATES_DIR" ]; then
        while IFS= read -r -d '' template_file; do
            local basename=$(basename "$template_file")
            local output_name="${basename%.tpl}"
            local output_file="${WORKSPACE_DIR}/${output_name}"
            
            log_info "Processing template: $basename -> $output_name"
            
            # Build substitution list
            local substitutions=(
                "TW_PORT=${TW_PORT}"
                "TW_HOST=${TW_HOST}"
                "WORKSPACE_DIR=${WORKSPACE_DIR}"
                "HOME_DIR=${HOME}"
                "USER=${USER}"
            )
            
            if substitute_template "$template_file" "$output_file" "${substitutions[@]}"; then
                config_files+=("$output_file")
            else
                log_error "Failed to process template: $template_file"
            fi
        done < <(find "$TEMPLATES_DIR" -name "*.tpl" -type f -print0 2>/dev/null || true)
    fi
    
    # Create default config.json if template doesn't exist
    local config_json="${WORKSPACE_DIR}/config.json"
    if [ ! -f "$config_json" ] && [ ${#config_files[@]} -eq 0 ]; then
        log_info "Creating default config.json"
        cat > "$config_json" <<EOF
{
  "TW_PORT": "${TW_PORT}",
  "TW_HOST": "${TW_HOST}",
  "WORKSPACE_DIR": "${WORKSPACE_DIR}",
  "HOME_DIR": "${HOME}"
}
EOF
        log_success "Default config.json created"
        config_files+=("$config_json")
    fi
    
    if [ ${#config_files[@]} -gt 0 ]; then
        log_success "Configuration files created: ${config_files[*]}"
    else
        log_warning "No configuration files were created"
    fi
    
    return 0
}

main() {
    check_not_root
    
    # Allow workspace directory to be overridden
    if [ -n "${1:-}" ]; then
        WORKSPACE_DIR="$1"
    fi
    
    configure_system
}

main "$@"

