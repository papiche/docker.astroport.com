#!/bin/bash
# Check system dependencies before installation
# This script verifies that all required tools are available

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${SCRIPT_DIR}/install.lib.sh"

# Required commands
REQUIRED_COMMANDS=(
    "git"
    "python3"
    "pip3"
    "jq"
)

# Optional but recommended commands
OPTIONAL_COMMANDS=(
    "whiptail"
    "systemctl"
)

check_dependencies() {
    log_info "Checking system dependencies..."
    
    local missing_required=()
    local missing_optional=()
    
    # Check required commands
    for cmd in "${REQUIRED_COMMANDS[@]}"; do
        if ! command_exists "$cmd"; then
            missing_required+=("$cmd")
        else
            log_success "$cmd is installed"
        fi
    done
    
    # Check optional commands
    for cmd in "${OPTIONAL_COMMANDS[@]}"; do
        if ! command_exists "$cmd"; then
            missing_optional+=("$cmd")
        else
            log_success "$cmd is installed (optional)"
        fi
    done
    
    # Report missing required commands
    if [ ${#missing_required[@]} -gt 0 ]; then
        log_error "Missing required dependencies: ${missing_required[*]}"
        log_info "Please install them before continuing:"
        for cmd in "${missing_required[@]}"; do
            case "$cmd" in
                "git")
                    echo "  - sudo apt-get install git"
                    ;;
                "python3")
                    echo "  - sudo apt-get install python3"
                    ;;
                "pip3")
                    echo "  - sudo apt-get install python3-pip"
                    ;;
                "jq")
                    echo "  - sudo apt-get install jq"
                    ;;
            esac
        done
        return 1
    fi
    
    # Warn about missing optional commands
    if [ ${#missing_optional[@]} -gt 0 ]; then
        log_warning "Missing optional dependencies: ${missing_optional[*]}"
        log_info "These are recommended but not required. Installation will continue."
    fi
    
    # Check Python version
    local python_version=$(python3 --version 2>&1 | awk '{print $2}')
    log_info "Python version: $python_version"
    
    # Check if we can write to home directory
    if [ ! -w "$HOME" ]; then
        log_error "Cannot write to home directory: $HOME"
        return 1
    fi
    
    log_success "All required dependencies are installed"
    return 0
}

main() {
    check_not_root
    check_dependencies
}

main "$@"

