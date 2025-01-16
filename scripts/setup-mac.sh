#!/bin/bash
# setup-mac.sh

# =============================================================================
# Developer Environment Setup Script for macOS
# -----------------------------------------------------------------------------
# Description:
#   This script prepares a development environment on macOS by installing
#   necessary tools and configuring the system for development use.
#
# Usage:
#   ./setup-mac.sh
#
# Notes:
#   - Installs Homebrew
#   - Configures PATH for Apple Silicon Macs
# =============================================================================

# Function: check_command
# -----------------------------------------------------------------------------
# Checks if a command is available
#
# Returns:
#   0 if command is available, 1 if not
# -----------------------------------------------------------------------------
check_command() {
    if command -v "$1" &>/dev/null; then
        return 0
    fi
    return 1
}

# Function: install_homebrew
# -----------------------------------------------------------------------------
# Install Homebrew and configure environment
#
# Side effects:
#   - Installing Homebrew
#   - Add configuration to .zprofile
# -----------------------------------------------------------------------------
install_homebrew() {
    # Hombrew official script url
    local script="https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh"

    # Install Homebrew using official script
    /bin/bash -c "$(curl -fsSL $script)"
    
    # Setup Homebrew path for zsh
    echo >> $HOME/.zprofile
    echo "# Homebrew" >> $HOME/.zprofile
    echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> $HOME/.zprofile
    eval "$(/opt/homebrew/bin/brew shellenv)"
}

