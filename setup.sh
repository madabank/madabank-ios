#!/bin/bash
set -e

# Text formatting
RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}🔄 Syncing git submodules...${NC}"
# Sync URLs from .gitmodules to .git/config
git submodule sync --recursive

# Update submodules to match the commit pointers in the main repo
# --init: Initialize any uninitialized submodules
# --recursive: Recurse into nested submodules
# --force: Discard local changes in submodules if deemed necessary to match upstream
git submodule update --init --recursive --force

echo -e "${BLUE}💎 Installing Ruby dependencies...${NC}"
if [ -f "Madabank/Gemfile" ]; then
    pushd Madabank > /dev/null
    bundle config set --local path 'vendor/bundle'
    bundle install
    popd > /dev/null
else
    echo "⚠️  Madabank/Gemfile not found, skipping bundle install."
fi

echo -e "${BLUE}📦 Installing Tuist dependencies...${NC}"
cd Madabank
if ! command -v tuist &> /dev/null; then
    echo -e "${RED}❌ Tuist not found. Installing...${NC}"
    curl -Ls https://install.tuist.io | bash
fi

tuist install

echo -e "${BLUE}🧹 Cleaning Tuist cache...${NC}"
tuist clean

echo -e "${BLUE}🛠  Generating project...${NC}"
tuist generate

echo -e "${GREEN}✅ Project setup complete!${NC}"
echo -e "ℹ️  Open ${BLUE}Madabank/Madabank.xcworkspace${NC} to start working."
