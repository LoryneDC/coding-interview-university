#!/usr/bin/env bash

# =============================================
# Git Progress Uploader for Coding Interview University
# Version: 1.2 (clean)
# =============================================

# Configuration
REPO_DIR="/home/krobus/coding-interview-university"
DEFAULT_COMMIT_MSG="Updated study progress"

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

function show_header() {
    echo -e "${CYAN}╔════════════════════════════════════╗"
    echo -e "║   Study Progress Git Uploader      ║"
    echo -e "╚════════════════════════════════════╝${NC}"
    echo
}

function check_changes() {
    echo -e "${BLUE}🔍 Checking for changes...${NC}"
    changes=$(git status --porcelain)
    
    if [ -z "$changes" ]; then
        echo -e "${YELLOW}⚠ No changes detected in your working directory.${NC}"
        echo -e "   Make sure you've saved all files before running this script."
        exit 0
    else
        echo -e "${GREEN}✓ Changes detected:${NC}"
        git status -s | while read -r line; do
            echo -e "   ${CYAN}•${NC} $line"
        done
        echo
    fi
}

function main() {
    show_header
    
    cd "$REPO_DIR" || {
        echo -e "${RED}✗ Error: Could not change to repository directory.${NC}"
        exit 1
    }

    check_changes

    # Commit message
    echo -e "${BLUE}💬 Describe your progress (press Enter for default):${NC}"
    echo -e "   Default: \"${YELLOW}${DEFAULT_COMMIT_MSG}${NC}\""
    read -r -p "   > " commit_message
    
    [ -z "$commit_message" ] && commit_message="$DEFAULT_COMMIT_MSG"

    # Confirmation
    echo -e "\n${BLUE}⚠ The following changes will be uploaded:${NC}"
    git status -s
    echo
    read -r -p "Are you sure you want to continue? [y/N] " response
    
    if [[ "$response" =~ ^([yY][eE][sS]|[yY])$ ]]; then
        echo -e "\n${BLUE}🚀 Uploading your progress...${NC}"
        
        echo -e "${CYAN}1. Staging changes...${NC}"
        git add .
        
        echo -e "${CYAN}2. Creating commit...${NC}"
        git commit -m "$commit_message"
        
        echo -e "${CYAN}3. Pushing to GitHub...${NC}"
        git push origin main
        
        echo -e "\n${GREEN}🎉 Success! Your progress has been uploaded.${NC}"
        echo -e "   ${YELLOW}Commit message:${NC} \"$commit_message\""
    else
        echo -e "\n${RED}✗ Operation cancelled. No changes were uploaded.${NC}"
    fi
}

main