#!/usr/bin/env bash

# =============================================
# Git Progress Uploader for Coding Interview University
# Version: 1.3 (Andromeda Theme)
# =============================================

# Configuration
REPO_DIR="/home/krobus/coding-interview-university"
DEFAULT_COMMIT_MSG="Updated study progress"

# Andromeda VS Code Theme Colors
BACKGROUND='\033[48;2;25;27;38m'
FOREGROUND='\033[38;2;171;178;191m'
TEXT='\033[38;2;171;178;191m'
BLUE='\033[38;2;122;162;247m'
CYAN='\033[38;2;96;220;227m'
GREEN='\033[38;2;158;206;106m'
YELLOW='\033[38;2;224;175;104m'
ORANGE='\033[38;2;247;140;108m'
PURPLE='\033[38;2;187;154;246m'
RED='\033[38;2;237;121;121m'
NC='\033[0m' # No Color

function show_header() {
    echo -e "${PURPLE}╔════════════════════════════════════════════╗"
    echo -e "║${BACKGROUND}         🚀 Git Progress Uploader           ${NC}${PURPLE}║"
    echo -e "╚════════════════════════════════════════════╝${NC}"
    echo
}

function check_changes() {
    echo -e "${BLUE}🔍 Scanning working directory...${NC}"
    changes=$(git status --porcelain)
    
    if [ -z "$changes" ]; then
        echo -e "${ORANGE}⚠ No changes detected${NC}"
        echo -e "${TEXT}   Make sure you've saved all files before running this script.${NC}"
        exit 0
    else
        echo -e "${GREEN}✓ Changes found:${NC}"
        git status -s | while read -r line; do
            echo -e "   ${CYAN}➤${NC} ${TEXT}$line${NC}"
        done
        echo
    fi
}

function main() {
    show_header
    
    cd "$REPO_DIR" || {
        echo -e "${RED}✗ Critical Error: Could not access repository${NC}"
        echo -e "${TEXT}   Path: ${ORANGE}$REPO_DIR${NC}"
        exit 1
    }

    check_changes

    # Commit message
    echo -e "${BLUE}💬 Progress Description:${NC}"
    echo -e "${TEXT}   Press Enter for default message${NC}"
    echo -e "${YELLOW}   Default: \"${DEFAULT_COMMIT_MSG}\"${NC}"
    echo -ne "${CYAN}   ➤ ${BLUE}"  # Cursor styling
    read -r -p "" commit_message
    
    [ -z "$commit_message" ] && commit_message="$DEFAULT_COMMIT_MSG"

    # Confirmation
    echo -e "\n${BLUE}⚠ Review Changes:${NC}"
    git status -s
    echo -e "\n${YELLOW}This action will:${NC}"
    echo -e "   ${CYAN}1.${NC} Stage all changes"
    echo -e "   ${CYAN}2.${NC} Create commit: ${GREEN}\"$commit_message\"${NC}"
    echo -e "   ${CYAN}3.${NC} Push to origin/main"
    echo -ne "\n${PURPLE}Confirm upload? [y/N] ${NC}"
    read -r -p "" response
    
    if [[ "$response" =~ ^([yY][eE][sS]|[yY])$ ]]; then
        echo -e "\n${BLUE}🚀 Launching upload sequence...${NC}"
        
        echo -e "${CYAN}⌛ Staging changes...${NC}"
        git add .
        
        echo -e "${CYAN}✍ Committing...${NC}"
        git commit -m "$commit_message"
        
        echo -e "${CYAN}📤 Pushing...${NC}"
        git push origin main
        
        echo -e "\n${GREEN}🎉 Mission accomplished!${NC}"
        echo -e "${TEXT}   Your study progress is now safe on GitHub${NC}"
        echo -e "   ${YELLOW}Commit ID:${NC} ${TEXT}$(git rev-parse --short HEAD)${NC}"
    else
        echo -e "\n${RED}✗ Operation aborted${NC}"
        echo -e "${TEXT}   No changes were uploaded${NC}"
    fi
}

main