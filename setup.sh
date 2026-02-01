#!/bin/bash
set -e

# Text formatting
RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Default values
CLEAN=false
FORCE_SUBMODULES=false

# Help menu
usage() {
    echo "Usage: $0 [OPTIONS]"
    echo "Options:"
    echo "  --clean       Clean Tuist cache and build artifacts before generating"
    echo "  --force       Force update submodules (WARNING: Discards local changes)"
    echo "  --help        Show this help message"
    exit 1
}

# Parse arguments
while [[ "$#" -gt 0 ]]; do
    case $1 in
        --clean) CLEAN=true ;;
        --force) FORCE_SUBMODULES=true ;;
        --help) usage ;;
        *) echo "Unknown parameter: $1"; usage ;;
    esac
    shift
done

echo -e "${BLUE}🚀 Starting Madabank setup...${NC}"

# Check dependencies
check_command() {
    if ! command -v "$1" &> /dev/null; then
        echo -e "${RED}❌ Error: '$1' is not installed.${NC}"
        echo -e "${YELLOW}Please install $1 to proceed.${NC}"
        exit 1
    fi
}

echo -e "${BLUE}🔍 Checking dependencies...${NC}"
check_command git
check_command swift

# Tuist check
if ! command -v tuist &> /dev/null; then
    echo -e "${YELLOW}⚠️  Tuist not found. Attempting to install via mise or curl...${NC}"
    if command -v mise &> /dev/null; then
         mise install tuist
    else
         curl -Ls https://install.tuist.io | bash
    fi
fi

# 1. Submodules
echo -e "${BLUE}🔄 Syncing git submodules...${NC}"
git submodule sync --recursive

if [ "$FORCE_SUBMODULES" = true ]; then
    echo -e "${YELLOW}⚠️  Forcing submodule update. Local changes will be discarded.${NC}"
    git submodule update --init --recursive --force
else
    echo -e "${BLUE}ℹ️  Updating submodules (safe mode)...${NC}"
    # updates only if it can be fast-forwarded or is clean
    git submodule update --init --recursive
fi

# 2. Ruby dependencies
echo -e "${BLUE}💎 Installing Ruby dependencies...${NC}"
if [ -f "Madabank/Gemfile" ]; then
    pushd Madabank > /dev/null
    bundle config set --local path 'vendor/bundle'
    bundle install
    popd > /dev/null
else
    echo -e "${YELLOW}⚠️  Madabank/Gemfile not found, skipping bundle install.${NC}"
fi

# 3. Tuist Setup
cd Madabank

echo -e "${BLUE}📦 Installing Tuist dependencies...${NC}"
tuist install

if [ "$CLEAN" = true ]; then
    echo -e "${BLUE}🧹 Cleaning Tuist cache (as requested)...${NC}"
    tuist clean
fi

echo -e "${BLUE}🛠  Generating project...${NC}"
tuist generate

echo -e "${GREEN}✅ Project setup complete!${NC}"
echo -e "ℹ️  Open ${BLUE}Madabank/Madabank.xcworkspace${NC} to start working."
