#!/bin/bash
# Build script for Astroport.ONE Docker images
# This script builds both production and development images

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

log_info() {
    echo -e "${BLUE}ℹ️  $1${NC}"
}

log_success() {
    echo -e "${GREEN}✅ $1${NC}"
}

log_warning() {
    echo -e "${YELLOW}⚠️  $1${NC}"
}

log_error() {
    echo -e "${RED}❌ $1${NC}"
}

# Default values
IMAGE_NAME="astroport-one"
TAG="latest"
BUILD_TYPE="production"

show_help() {
    cat << EOF
Build Astroport.ONE Docker images

USAGE:
    ./docker-build.sh [OPTIONS]

OPTIONS:
    -t, --tag TAG         Docker image tag (default: latest)
    -n, --name NAME       Docker image name (default: astroport-one)
    -d, --dev             Build development image instead of production
    -h, --help            Show this help message

EXAMPLES:
    ./docker-build.sh                    # Build production image
    ./docker-build.sh --dev              # Build development image
    ./docker-build.sh -t v1.0.0          # Build with specific tag
    ./docker-build.sh --dev -t dev       # Build dev image with tag

EOF
}

parse_args() {
    while [[ $# -gt 0 ]]; do
        case $1 in
            -t|--tag)
                TAG="$2"
                shift 2
                ;;
            -n|--name)
                IMAGE_NAME="$2"
                shift 2
                ;;
            -d|--dev)
                BUILD_TYPE="development"
                shift
                ;;
            -h|--help)
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

build_image() {
    local dockerfile="Dockerfile"
    if [ "$BUILD_TYPE" = "development" ]; then
        dockerfile="Dockerfile.dev"
        log_info "Building development image..."
    else
        log_info "Building production image..."
    fi
    
    if [ ! -f "$dockerfile" ]; then
        log_error "Dockerfile not found: $dockerfile"
        return 1
    fi
    
    local full_image_name="${IMAGE_NAME}:${TAG}"
    if [ "$BUILD_TYPE" = "development" ]; then
        full_image_name="${IMAGE_NAME}-dev:${TAG}"
    fi
    
    log_info "Building image: $full_image_name"
    log_info "Using Dockerfile: $dockerfile"
    
    if docker build -f "$dockerfile" -t "$full_image_name" .; then
        log_success "Image built successfully: $full_image_name"
        
        # Show image info
        log_info "Image details:"
        docker images "$full_image_name" --format "table {{.Repository}}\t{{.Tag}}\t{{.Size}}\t{{.CreatedAt}}"
        
        return 0
    else
        log_error "Failed to build image"
        return 1
    fi
}

main() {
    echo ""
    echo -e "${BLUE}╔═══════════════════════════════════════════════════════════════════════════════╗${NC}"
    echo -e "${BLUE}║                                                                               ║${NC}"
    echo -e "${BLUE}║          Astroport.ONE Docker Image Builder                                 ║${NC}"
    echo -e "${BLUE}║                                                                               ║${NC}"
    echo -e "${BLUE}╚═══════════════════════════════════════════════════════════════════════════════╝${NC}"
    echo ""
    
    parse_args "$@"
    
    # Check if Docker is available
    if ! command -v docker &> /dev/null; then
        log_error "Docker is not installed or not in PATH"
        log_info "Please install Docker: https://docs.docker.com/get-docker/"
        exit 1
    fi
    
    # Check if we're in the right directory
    if [ ! -f "install.NEW.sh" ]; then
        log_error "install.NEW.sh not found. Please run this script from the project root."
        exit 1
    fi
    
    build_image
}

main "$@"

