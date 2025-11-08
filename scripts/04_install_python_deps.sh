#!/bin/bash
# Install Python dependencies for all projects
# This script is idempotent: it will upgrade packages if already installed

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${SCRIPT_DIR}/install.lib.sh"

# Default workspace directory
WORKSPACE_DIR="${WORKSPACE_DIR:-${HOME}/.zen/workspace}"

# Virtual environment directory
VENV_DIR="${VENV_DIR:-${HOME}/.astro}"

# Projects with requirements.txt
PROJECTS=(
    "UPassport"
    "UPlanet"
    "H2G2"
)

install_python_deps() {
    log_info "Installing Python dependencies"
    
    # Create virtual environment if it doesn't exist
    if [ ! -d "$VENV_DIR" ]; then
        log_info "Creating virtual environment: $VENV_DIR"
        python3 -m venv "$VENV_DIR"
        log_success "Virtual environment created"
    else
        log_info "Virtual environment already exists: $VENV_DIR"
    fi
    
    # Activate virtual environment
    source "$VENV_DIR/bin/activate"
    
    # Upgrade pip
    log_info "Upgrading pip..."
    pip install --upgrade pip --quiet
    
    local failed_projects=()
    
    # Install dependencies for each project
    for project in "${PROJECTS[@]}"; do
        local project_path="${WORKSPACE_DIR}/${project}"
        local requirements_file="${project_path}/requirements.txt"
        
        if [ ! -d "$project_path" ]; then
            log_warning "Project directory not found: $project_path. Skipping..."
            continue
        fi
        
        if [ -f "$requirements_file" ]; then
            log_info "Installing dependencies for $project..."
            if pip install -r "$requirements_file" --quiet; then
                log_success "Dependencies installed for $project"
            else
                log_error "Failed to install dependencies for $project"
                failed_projects+=("$project")
            fi
        else
            log_warning "requirements.txt not found for $project. Skipping..."
        fi
    done
    
    # Also check for root-level requirements.txt
    if [ -f "${SCRIPT_DIR}/../requirements.txt" ]; then
        log_info "Installing root-level requirements..."
        pip install -r "${SCRIPT_DIR}/../requirements.txt" --quiet
        log_success "Root-level dependencies installed"
    fi
    
    if [ ${#failed_projects[@]} -gt 0 ]; then
        log_error "Failed to install dependencies for: ${failed_projects[*]}"
        return 1
    fi
    
    log_success "All Python dependencies are installed"
    return 0
}

main() {
    check_not_root
    
    # Allow workspace directory to be overridden
    if [ -n "${1:-}" ]; then
        WORKSPACE_DIR="$1"
    fi
    
    install_python_deps
}

main "$@"

