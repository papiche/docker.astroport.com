#!/bin/bash
# Clone or update all required repositories
# This script is idempotent: it will update existing repositories instead of failing

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${SCRIPT_DIR}/install.lib.sh"

# Default workspace directory
WORKSPACE_DIR="${WORKSPACE_DIR:-${HOME}/.zen/workspace}"

# Repository configuration: URL, target directory, branch
# Format: "url|target_dir|branch"
REPOSITORIES=(
    "https://github.com/papiche/UPassport.git|UPassport|main"
    "https://github.com/papiche/UPlanet.git|UPlanet|main"
    "https://github.com/papiche/Astroport.ONE.git|Astroport.ONE|main"
    "https://github.com/papiche/NIP-101.git|NIP-101|main"
    "https://github.com/papiche/OC2UPlanet.git|OC2UPlanet|main"
    "https://github.com/papiche/G1BILLET.git|G1BILLET|main"
)

clone_repositories() {
    log_info "Cloning/updating repositories in $WORKSPACE_DIR"
    
    # Create workspace directory if it doesn't exist
    if [ ! -d "$WORKSPACE_DIR" ]; then
        log_info "Creating workspace directory: $WORKSPACE_DIR"
        mkdir -p "$WORKSPACE_DIR"
    fi
    
    local original_dir=$(pwd)
    cd "$WORKSPACE_DIR"
    
    local failed_repos=()
    
    for repo_config in "${REPOSITORIES[@]}"; do
        IFS='|' read -r repo_url target_dir branch <<< "$repo_config"
        
        # Use main as default branch if not specified
        branch="${branch:-main}"
        
        log_info "Processing repository: $target_dir"
        
        if git_clone_or_update "$repo_url" "$target_dir" "$branch"; then
            log_success "Repository $target_dir ready"
        else
            log_error "Failed to process repository: $target_dir"
            failed_repos+=("$target_dir")
        fi
    done
    
    cd "$original_dir"
    
    if [ ${#failed_repos[@]} -gt 0 ]; then
        log_error "Failed to clone/update repositories: ${failed_repos[*]}"
        return 1
    fi
    
    log_success "All repositories are ready"
    return 0
}

main() {
    check_not_root
    
    # Allow workspace directory to be overridden
    if [ -n "${1:-}" ]; then
        WORKSPACE_DIR="$1"
    fi
    
    clone_repositories
}

main "$@"

