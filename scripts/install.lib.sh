#!/bin/bash
# Common utilities for install.NEW.sh modules
# Provides error handling, logging, and helper functions

set -euo pipefail

# Colors for output
readonly RED='\033[0;31m'
readonly GREEN='\033[0;32m'
readonly YELLOW='\033[1;33m'
readonly BLUE='\033[0;34m'
readonly NC='\033[0m' # No Color

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

# Error handling wrapper
run_step() {
    local step_name="$1"
    shift
    local command=("$@")
    
    log_info "Running: $step_name"
    
    if "${command[@]}"; then
        log_success "$step_name completed"
        return 0
    else
        local exit_code=$?
        log_error "$step_name failed with exit code $exit_code"
        return $exit_code
    fi
}

# Check if a command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Check if a directory exists and is a git repository
is_git_repo() {
    [ -d "$1" ] && [ -d "$1/.git" ]
}

# Idempotent git clone or update
git_clone_or_update() {
    local repo_url="$1"
    local target_dir="$2"
    local branch="${3:-main}"
    
    if [ -d "$target_dir" ]; then
        if is_git_repo "$target_dir"; then
            log_info "$target_dir exists and is a git repository. Updating..."
            cd "$target_dir"
            git fetch origin
            git checkout "$branch" 2>/dev/null || git checkout -b "$branch" "origin/$branch" 2>/dev/null || true
            git pull origin "$branch" || {
                log_warning "Could not pull latest changes. Repository may have local changes."
                return 0
            }
            cd - >/dev/null
            log_success "$target_dir updated"
        else
            log_warning "$target_dir exists but is not a git repository. Skipping..."
            return 1
        fi
    else
        log_info "Cloning $repo_url to $target_dir..."
        git clone -b "$branch" "$repo_url" "$target_dir" || {
            log_error "Failed to clone $repo_url"
            return 1
        }
        log_success "$target_dir cloned"
    fi
    return 0
}

# Check if a symlink exists and points to the correct target
symlink_exists() {
    local link_path="$1"
    local target_path="$2"
    
    [ -L "$link_path" ] && [ "$(readlink -f "$link_path")" = "$(readlink -f "$target_path")" ]
}

# Create symlink idempotently
create_symlink() {
    local target="$1"
    local link_path="$2"
    
    if symlink_exists "$link_path" "$target"; then
        log_info "Symlink $link_path already exists and points to correct target"
        return 0
    fi
    
    if [ -e "$link_path" ] && [ ! -L "$link_path" ]; then
        log_warning "$link_path exists but is not a symlink. Backing up..."
        mv "$link_path" "${link_path}.backup.$(date +%s)"
    fi
    
    local link_dir=$(dirname "$link_path")
    if [ ! -d "$link_dir" ]; then
        mkdir -p "$link_dir"
    fi
    
    ln -sfn "$target" "$link_path"
    log_success "Symlink created: $link_path -> $target"
}

# Template substitution using sed (following user preference)
substitute_template() {
    local template_file="$1"
    local output_file="$2"
    shift 2
    local substitutions=("$@")
    
    if [ ! -f "$template_file" ]; then
        log_error "Template file not found: $template_file"
        return 1
    fi
    
    cp "$template_file" "$output_file"
    
    for sub in "${substitutions[@]}"; do
        local var_name=$(echo "$sub" | cut -d'=' -f1)
        local var_value=$(echo "$sub" | cut -d'=' -f2-)
        sed -i "s|__${var_name}__|${var_value}|g" "$output_file"
    done
    
    log_success "Template $template_file processed to $output_file"
}

# Check if running as root (should not)
check_not_root() {
    if [ "$(id -u)" -eq 0 ]; then
        log_error "This script should not be run as root. Use sudo for specific commands only."
        exit 1
    fi
}

# Get script directory
get_script_dir() {
    cd "$(dirname "${BASH_SOURCE[1]}")" && pwd
}

