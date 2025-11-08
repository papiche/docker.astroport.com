#!/bin/bash
# ⚠️  WARNING: This script is AI-generated and needs to be tested
# ⚠️  This is a NEW modular installation script for UPlanet ecosystem
# ⚠️  Please test thoroughly before using in production
#
# Professional modular installation script for UPlanet ecosystem
# This script is idempotent, modular, and provides better error handling
#
# Usage: ./install.NEW.sh [OPTIONS]
# Options:
#   --workspace DIR    Set workspace directory (default: ~/.zen/workspace)
#   --skip-step N     Skip step N (1-8)
#   --only-step N      Run only step N (1-8)
#   --verbose          Enable verbose output
#   --help             Show this help message

set -euo pipefail

# Script directory
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SCRIPTS_DIR="${SCRIPT_DIR}/scripts"

# Colors for output
readonly RED='\033[0;31m'
readonly GREEN='\033[0;32m'
readonly YELLOW='\033[1;33m'
readonly BLUE='\033[0;34m'
readonly NC='\033[0m' # No Color

# Default configuration
WORKSPACE_DIR="${HOME}/.zen/workspace"
VERBOSE=false
SKIP_STEPS=()
ONLY_STEP=""

# Logging functions
log_info() {
    echo -e "${BLUE}ℹ️  $1${NC}" >&2
}

log_success() {
    echo -e "${GREEN}✅ $1${NC}" >&2
}

log_warning() {
    echo -e "${YELLOW}⚠️  $1${NC}" >&2
}

log_error() {
    echo -e "${RED}❌ $1${NC}" >&2
}

log_step() {
    echo ""
    echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e "${BLUE}  STEP $1: $2${NC}"
    echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo ""
}

# Show help
show_help() {
    cat << EOF
⚠️  WARNING: This script is AI-generated and needs to be tested ⚠️

Professional Modular Installation Script for UPlanet Ecosystem

USAGE:
    ./install.NEW.sh [OPTIONS]

OPTIONS:
    --workspace DIR    Set workspace directory (default: ~/.zen/workspace)
    --skip-step N      Skip step N (can be used multiple times)
    --only-step N      Run only step N (1-9)
    --verbose          Enable verbose output
    --help             Show this help message

STEPS:
    1. Check Dependencies      - Verify required tools are installed
    2. Clone Repositories       - Clone or update git repositories
    3. Setup Symlinks          - Create symbolic links for easy access
    4. Install Python Deps     - Install Python dependencies
    5. Configure System        - Setup configuration files from templates
    6. Setup Services          - Configure systemd services
    7. Process 20h12           - Run additional installation steps
    8. Install Strfry          - Install and configure strfry NOSTR relay
    9. Setup Captain           - Captain onboarding (optional, interactive)

EXAMPLES:
    ./install.NEW.sh                           # Full installation
    ./install.NEW.sh --only-step 1             # Only check dependencies
    ./install.NEW.sh --skip-step 6            # Skip service setup
    ./install.NEW.sh --workspace /custom/path # Use custom workspace

EOF
}

# Check if step should be skipped
should_skip_step() {
    local step_num="$1"
    for skip in "${SKIP_STEPS[@]}"; do
        if [ "$skip" = "$step_num" ]; then
            return 0
        fi
    done
    return 1
}

# Check if step should run
should_run_step() {
    local step_num="$1"
    
    # If ONLY_STEP is set, only run that step
    if [ -n "$ONLY_STEP" ]; then
        [ "$ONLY_STEP" = "$step_num" ]
    else
        # Otherwise, run if not skipped
        ! should_skip_step "$step_num"
    fi
}

# Run a step with error handling
run_step() {
    local step_num="$1"
    local step_name="$2"
    local step_script="$3"
    
    if ! should_run_step "$step_num"; then
        log_info "Skipping step $step_num: $step_name"
        return 0
    fi
    
    log_step "$step_num" "$step_name"
    
    if [ ! -f "$step_script" ]; then
        log_error "Step script not found: $step_script"
        return 1
    fi
    
    # Make script executable
    chmod +x "$step_script"
    
    # Run the step script
    local start_time=$(date +%s)
    
    if WORKSPACE_DIR="$WORKSPACE_DIR" bash "$step_script" "$WORKSPACE_DIR"; then
        local end_time=$(date +%s)
        local duration=$((end_time - start_time))
        log_success "Step $step_num completed in ${duration}s"
        return 0
    else
        local exit_code=$?
        log_error "Step $step_num failed with exit code $exit_code"
        return $exit_code
    fi
}

# Parse command line arguments
parse_args() {
    while [[ $# -gt 0 ]]; do
        case $1 in
            --workspace)
                WORKSPACE_DIR="$2"
                shift 2
                ;;
            --skip-step)
                SKIP_STEPS+=("$2")
                shift 2
                ;;
            --only-step)
                ONLY_STEP="$2"
                shift 2
                ;;
            --verbose)
                VERBOSE=true
                set -x
                shift
                ;;
            --help)
                show_help
                exit 0
                ;;
            *)
                log_error "Unknown option: $1"
                show_help
                exit 1
                ;;
        esac
    done
}

# Main installation function
main() {
    echo ""
    echo -e "${YELLOW}╔═══════════════════════════════════════════════════════════════════════════════╗${NC}"
    echo -e "${YELLOW}║                                                                               ║${NC}"
    echo -e "${YELLOW}║  ⚠️  WARNING: This script is AI-generated and needs to be tested ⚠️         ║${NC}"
    echo -e "${YELLOW}║                                                                               ║${NC}"
    echo -e "${YELLOW}╚═══════════════════════════════════════════════════════════════════════════════╝${NC}"
    echo ""
    echo -e "${GREEN}╔═══════════════════════════════════════════════════════════════════════════════╗${NC}"
    echo -e "${GREEN}║                                                                               ║${NC}"
    echo -e "${GREEN}║          UPlanet Professional Installation Script (NEW Mode)                  ║${NC}"
    echo -e "${GREEN}║                                                                               ║${NC}"
    echo -e "${GREEN}╚═══════════════════════════════════════════════════════════════════════════════╝${NC}"
    echo ""
    
    log_info "Workspace directory: $WORKSPACE_DIR"
    log_info "Scripts directory: $SCRIPTS_DIR"
    echo ""
    
    # Check if scripts directory exists
    if [ ! -d "$SCRIPTS_DIR" ]; then
        log_error "Scripts directory not found: $SCRIPTS_DIR"
        log_info "Please ensure all script modules are present"
        exit 1
    fi
    
    # Check if running as root (should not)
    if [ "$(id -u)" -eq 0 ]; then
        log_error "This script should not be run as root. Use sudo for specific commands only."
        exit 1
    fi
    
    local overall_start_time=$(date +%s)
    local failed_steps=()
    
    # Run all installation steps
    run_step "1" "Check Dependencies" "${SCRIPTS_DIR}/01_check_dependencies.sh" || failed_steps+=("1")
    run_step "2" "Clone Repositories" "${SCRIPTS_DIR}/02_clone_repositories.sh" || failed_steps+=("2")
    run_step "3" "Setup Symlinks" "${SCRIPTS_DIR}/03_setup_symlinks.sh" || failed_steps+=("3")
    run_step "4" "Install Python Dependencies" "${SCRIPTS_DIR}/04_install_python_deps.sh" || failed_steps+=("4")
    run_step "5" "Configure System" "${SCRIPTS_DIR}/05_configure_system.sh" || failed_steps+=("5")
    run_step "6" "Setup Services" "${SCRIPTS_DIR}/06_setup_services.sh" || failed_steps+=("6")
    run_step "7" "Process 20h12" "${SCRIPTS_DIR}/07_process_20h12.sh" || failed_steps+=("7")
    run_step "8" "Install Strfry" "${SCRIPTS_DIR}/08_install_strfry.sh" || failed_steps+=("8")
    
    # Step 9 is optional and interactive - ask user if they want to run it
    if should_run_step "9"; then
        echo ""
        log_info "Step 9: Captain Setup (optional, interactive)"
        log_info "This step will help you:"
        log_info "  - Create your MULTIPASS and ZEN Card accounts"
        log_info "  - Initialize UPlanet cooperative wallets"
        log_info "  - Configure solar time cron for 20h12.process.sh"
        log_info "  - Set up PAF armateur registration"
        echo ""
        read -p "Would you like to run captain setup now? (y/N): " run_captain
        if [[ "$run_captain" =~ ^[Yy]$ ]]; then
            run_step "9" "Setup Captain" "${SCRIPTS_DIR}/09_setup_captain.sh" || failed_steps+=("9")
        else
            log_info "Skipping captain setup. You can run it later with:"
            log_info "  ./install.NEW.sh --only-step 9"
        fi
    fi
    
    # Summary
    local overall_end_time=$(date +%s)
    local overall_duration=$((overall_end_time - overall_start_time))
    
    echo ""
    echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e "${BLUE}  INSTALLATION SUMMARY${NC}"
    echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo ""
    
    if [ ${#failed_steps[@]} -eq 0 ]; then
        log_success "All installation steps completed successfully!"
        log_info "Total installation time: ${overall_duration}s"
        echo ""
        log_info "Next steps:"
        log_info "  - Review configuration files in: $WORKSPACE_DIR"
        log_info "  - Start services if needed: sudo systemctl start upassport"
        log_info "  - Check logs: journalctl -u upassport -f"
        echo ""
        return 0
    else
        log_error "Installation completed with errors"
        log_error "Failed steps: ${failed_steps[*]}"
        log_info "Total installation time: ${overall_duration}s"
        echo ""
        log_info "You can retry failed steps individually:"
        for step in "${failed_steps[@]}"; do
            log_info "  ./install.NEW.sh --only-step $step"
        done
        echo ""
        return 1
    fi
}

# Parse arguments and run main
parse_args "$@"
main

