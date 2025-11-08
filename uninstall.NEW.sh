#!/bin/bash
# ⚠️  WARNING: This script is AI-generated and needs to be tested
# ⚠️  This is a NEW modular uninstaller for Astroport.ONE
# ⚠️  Please test thoroughly before using in production
#
# Professional modular uninstallation script for Astroport.ONE ecosystem
# This script is idempotent, modular, and provides better error handling
#
# Usage: ./uninstall.NEW.sh [OPTIONS]
# Options:
#   --skip-step N     Skip step N (1-9)
#   --only-step N      Run only step N (1-9)
#   --verbose          Enable verbose output
#   --help             Show this help message
#   --non-interactive  Skip all interactive prompts (use defaults)

set -euo pipefail

# Script directory
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
UNINSTALL_SCRIPTS_DIR="${SCRIPT_DIR}/scripts/uninstall"

# Colors for output
readonly RED='\033[0;31m'
readonly GREEN='\033[0;32m'
readonly YELLOW='\033[1;33m'
readonly BLUE='\033[0;34m'
readonly NC='\033[0m' # No Color

# Default configuration
VERBOSE=false
SKIP_STEPS=()
ONLY_STEP=""
NON_INTERACTIVE=false

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

Professional Modular Uninstallation Script for Astroport.ONE Ecosystem

USAGE:
    ./uninstall.NEW.sh [OPTIONS]

OPTIONS:
    --skip-step N      Skip step N (can be used multiple times)
    --only-step N      Run only step N (1-9)
    --verbose          Enable verbose output
    --non-interactive  Skip all interactive prompts
    --help             Show this help message

STEPS:
    1. Stop Services          - Stop and disable all systemd services
    2. Remove Service Files   - Remove systemd service configuration files
    3. Remove Cron Jobs      - Remove cron jobs related to Astroport.ONE
    4. Remove Sudoers        - Remove custom sudoers files
    5. Remove Binaries       - Remove local binaries and symlinks
    6. Restore System Config  - Restore system configuration files
    7. Remove Desktop Shortcuts - Remove desktop shortcuts
    8. Clean Bashrc          - Clean bashrc from Astroport modifications
    9. Cleanup Directories   - Final cleanup and mark directories for deletion

EXAMPLES:
    ./uninstall.NEW.sh                    # Full uninstallation (interactive)
    ./uninstall.NEW.sh --non-interactive  # Full uninstallation (non-interactive)
    ./uninstall.NEW.sh --only-step 1      # Only stop services
    ./uninstall.NEW.sh --skip-step 9       # Skip directory cleanup

⚠️  WARNING: This will remove all Astroport.ONE components!
⚠️  This action cannot be undone!

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
    
    if bash "$step_script"; then
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
            --non-interactive)
                NON_INTERACTIVE=true
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

# Confirmation prompt
confirm_uninstall() {
    if [ "$NON_INTERACTIVE" = true ]; then
        log_warning "Non-interactive mode: proceeding with uninstallation"
        return 0
    fi
    
    echo ""
    echo -e "${RED}╔═══════════════════════════════════════════════════════════════════════════════╗${NC}"
    echo -e "${RED}║                                                                               ║${NC}"
    echo -e "${RED}║          ⚠️  WARNING: This will remove all Astroport.ONE components! ⚠️    ║${NC}"
    echo -e "${RED}║                                                                               ║${NC}"
    echo -e "${RED}║          This action cannot be undone!                                      ║${NC}"
    echo -e "${RED}╚═══════════════════════════════════════════════════════════════════════════════╝${NC}"
    echo ""
    
    read -p "Are you sure you want to continue? (yes/no): " confirm
    
    if [[ "$confirm" != "yes" ]]; then
        log_info "Uninstall cancelled."
        exit 0
    fi
}

# Main uninstallation function
main() {
    echo ""
    echo -e "${YELLOW}╔═══════════════════════════════════════════════════════════════════════════════╗${NC}"
    echo -e "${YELLOW}║                                                                               ║${NC}"
    echo -e "${YELLOW}║  ⚠️  WARNING: This script is AI-generated and needs to be tested ⚠️         ║${NC}"
    echo -e "${YELLOW}║                                                                               ║${NC}"
    echo -e "${YELLOW}╚═══════════════════════════════════════════════════════════════════════════════╝${NC}"
    echo ""
    echo -e "${RED}╔═══════════════════════════════════════════════════════════════════════════════╗${NC}"
    echo -e "${RED}║                                                                               ║${NC}"
    echo -e "${RED}║          Astroport.ONE Complete Uninstaller (NEW Mode)                      ║${NC}"
    echo -e "${RED}║                                                                               ║${NC}"
    echo -e "${RED}╚═══════════════════════════════════════════════════════════════════════════════╝${NC}"
    echo ""
    
    # Check if running as root (should not)
    if [ "$(id -u)" -eq 0 ]; then
        log_error "This script should not be run as root. Use sudo for specific commands only."
        exit 1
    fi
    
    # Check if uninstall scripts directory exists
    if [ ! -d "$UNINSTALL_SCRIPTS_DIR" ]; then
        log_error "Uninstall scripts directory not found: $UNINSTALL_SCRIPTS_DIR"
        log_info "Please ensure all uninstall script modules are present"
        exit 1
    fi
    
    # Confirmation
    confirm_uninstall
    
    log_info "Starting complete uninstall process..."
    echo ""
    
    local overall_start_time=$(date +%s)
    local failed_steps=()
    
    # Run all uninstallation steps
    run_step "1" "Stop Services" "${UNINSTALL_SCRIPTS_DIR}/01_stop_services.sh" || failed_steps+=("1")
    run_step "2" "Remove Service Files" "${UNINSTALL_SCRIPTS_DIR}/02_remove_service_files.sh" || failed_steps+=("2")
    run_step "3" "Remove Cron Jobs" "${UNINSTALL_SCRIPTS_DIR}/03_remove_cron_jobs.sh" || failed_steps+=("3")
    run_step "4" "Remove Sudoers" "${UNINSTALL_SCRIPTS_DIR}/04_remove_sudoers.sh" || failed_steps+=("4")
    run_step "5" "Remove Binaries" "${UNINSTALL_SCRIPTS_DIR}/05_remove_binaries.sh" || failed_steps+=("5")
    run_step "6" "Restore System Config" "${UNINSTALL_SCRIPTS_DIR}/06_restore_system_config.sh" || failed_steps+=("6")
    run_step "7" "Remove Desktop Shortcuts" "${UNINSTALL_SCRIPTS_DIR}/07_remove_desktop_shortcuts.sh" || failed_steps+=("7")
    run_step "8" "Clean Bashrc" "${UNINSTALL_SCRIPTS_DIR}/08_clean_bashrc.sh" || failed_steps+=("8")
    run_step "9" "Cleanup Directories" "${UNINSTALL_SCRIPTS_DIR}/09_cleanup_directories.sh" || failed_steps+=("9")
    
    # Summary
    local overall_end_time=$(date +%s)
    local overall_duration=$((overall_end_time - overall_start_time))
    
    echo ""
    echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e "${BLUE}  UNINSTALLATION SUMMARY${NC}"
    echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo ""
    
    if [ ${#failed_steps[@]} -eq 0 ]; then
        log_success "All uninstallation steps completed successfully!"
        log_info "Total uninstallation time: ${overall_duration}s"
        echo ""
        log_info "The following has been removed/disabled:"
        log_info "  ✓ All systemd services stopped and disabled"
        log_info "  ✓ Service configuration files removed"
        log_info "  ✓ Cron jobs removed"
        log_info "  ✓ Sudo permissions revoked"
        log_info "  ✓ Local binaries and symlinks removed"
        log_info "  ✓ System configuration restored"
        log_info "  ✓ Desktop shortcuts removed"
        echo ""
        log_warning "MANUAL CLEANUP REQUIRED:"
        log_info "  - ~/.zen directory renamed to ~/.zen.todelete"
        log_info "  - Run: rm -rf ~/.zen.todelete (after backing up any important data)"
        echo ""
        log_info "REBOOT RECOMMENDED to ensure all changes take effect."
        echo ""
        return 0
    else
        log_error "Uninstallation completed with errors"
        log_error "Failed steps: ${failed_steps[*]}"
        log_info "Total uninstallation time: ${overall_duration}s"
        echo ""
        log_info "You can retry failed steps individually:"
        for step in "${failed_steps[@]}"; do
            log_info "  ./uninstall.NEW.sh --only-step $step"
        done
        echo ""
        return 1
    fi
}

# Parse arguments and run main
parse_args "$@"
main

