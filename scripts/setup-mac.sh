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

# Function: check-command
# -----------------------------------------------------------------------------
# Checks if a command is available
#
# Returns:
#   0 if command is available, 1 if not
# -----------------------------------------------------------------------------
check-command() {
    if command -v "$1" &>/dev/null; then
        return 0
    fi
    return 1
}

# Function: depend
# -----------------------------------------------------------------------------
# Check for a required command and execute a fallback function if not found
#
# Description:
#   This function verifies whether a specified command is available on the system.
#   If the command is not found, it will execute a provided fallback function.
#   This is useful for ensuring dependencies are installed or handled dynamically.
#
# Usage:
#   depend <command> <fallback_function>
#
# Parameters:
#   <command>          The name of the command to check.
#   <fallback_function> The name of the function to execute if the command is not found.
#
# Notes:
#   - The fallback function must be defined and executable in the same script.
#   - Use this function to ensure required tools or commands are available before
#     proceeding with other operations.
#
# Example:
#   depend "curl" "install_curl"
# -----------------------------------------------------------------------------
depend() {
  if ! command -v "$1" &> /dev/null; then
    $2
  fi
}

# Function: install-homebrew
# -----------------------------------------------------------------------------
# Install Homebrew and configure environment
#
# Side effects:
#   - Installing Homebrew
#   - Add configuration to .zprofile
# -----------------------------------------------------------------------------
install-homebrew() {
    if command -v brew >/dev/null; then
        return 0
    fi

    # Homebrew official script URL
    local script="https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh"

    # Step 1: Install Homebrew using official script
    echo "Installing Homebrew..."
    /bin/bash -c "$(curl -fsSL $script)"
    
    # Step 2: Setup Homebrew path for zsh
    echo "Setting up Homebrew in .zprofile..."
    echo >> $HOME/.zprofile
    echo "# Homebrew" >> $HOME/.zprofile
    echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> $HOME/.zprofile
    
    # Step 3: Apply Homebrew configuration immediately for the current session
    echo "Applying Homebrew path for the current session..."
    eval "$(/opt/homebrew/bin/brew shellenv)"
    
    echo "Homebrew installation and setup completed."
}

# Function: install-mysql
# -----------------------------------------------------------------------------
# Installs MySQL and configures it for use on macOS
#
# Usage:
#   install-mysql
# -----------------------------------------------------------------------------
install-mysql() {
    depend brew install-homebrew
    # Check if MySQL is already installed
    if check-command "mysql"; then
        echo "MySQL is already installed."
    else
        echo "Installing MySQL..."
        brew install mysql
    fi

    # Start MySQL service
    echo "Starting MySQL service..."
    brew services start mysql

    echo "MySQL installation and configuration completed."
}

# Function: install-arc
# -----------------------------------------------------------------------------
# Install Arc Browser on macOS
#
# Usage:
#   install-arc
# -----------------------------------------------------------------------------
install-arc() {
    depend brew install-homebrew
    # Step 1: Check if Arc Browser is already installed
    if [ -d "/Applications/Arc.app" ]; then
        echo "Arc Browser is already installed."
    else
        echo "Installing Arc Browser..."
        # Install Arc Browser using Homebrew
        brew install --cask arc
    fi

    # Step 2: Completion message
    echo "Arc Browser installation and configuration completed."
}

# Function: install-proton-pass
# -----------------------------------------------------------------------------
# Install Proton Pass on macOS
#
# Usage:
#   install-proton-pass
# -----------------------------------------------------------------------------
install-proton-pass() {
    depend brew install-homebrew
    # Step 1: Check if Proton Pass is already installed
    if [ -d "/Applications/Proton Pass.app" ]; then
        echo "Proton Pass is already installed."
    else
        echo "Installing Proton Pass..."
        # Install Proton Pass using Homebrew
        brew install --cask proton-pass
    fi

    # Step 2: Completion message
    echo "Proton Pass installation and configuration completed."
}

# Function: install-mas
# -----------------------------------------------------------------------------
# Install or check if the Mac App Store command-line interface (mas) is installed
#
# Usage:
#   install-mas
# -----------------------------------------------------------------------------
install-mas() {
    depend brew install-homebrew
    # Step 1: Check if mas is already installed
    if check_command "mas"; then
        echo "mas is already installed."
    else
        echo "Installing mas (Mac App Store CLI)..."
        # Install mas using Homebrew
        brew install mas
    fi

    # Step 2: Verify installation and version
    echo "Verifying mas installation..."
    mas_version=$(mas version)
    echo "mas version: $mas_version"

    # Step 3: Completion message
    echo "mas installation and configuration completed."
}

# Function: install-xcode
# -----------------------------------------------------------------------------
# Install Xcode from the Mac App Store using mas CLI
#
# Usage:
#   install-xcode
# -----------------------------------------------------------------------------
install-xcode() {
    depend mas install-mas
    # Step 1: Check if Xcode is already installed
    if [ -d "/Applications/Xcode.app" ]; then
        echo "Xcode is already installed."
    else
        echo "Xcode is not installed. Installing Xcode from the Mac App Store..."
        
        # Step 2: Install Xcode using mas CLI (macOS App Store)
        echo "Xcode installation started. Please wait for the installation to complete."
        mas install 497799835

        # Step 3: Accept the Xcode license agreement after installation
        echo "Accepting Xcode license agreement..."
        sudo xcode-select --switch /Applications/Xcode.app/Contents/Developer
        sudo xcodebuild -license accept
        sudo xcodebuild -runFirstLaunch
    fi

    # Step 4: Completion message
    echo "Xcode installation and configuration completed."
}

# Function: install-cocoapods
# -----------------------------------------------------------------------------
# Install CocoaPods (dependency manager for iOS projects)
#
# Usage:
#   install-cocoapods
# -----------------------------------------------------------------------------
install-cocoapods() {
    depend brew install-homebrew
    echo "Installing CocoaPods..."
    brew install cocoapods
    echo "CocoaPods installation completed."
}

# Function: install-simulator
# -----------------------------------------------------------------------------
# Install iOS simulator for development
#
# Usage:
#   install-simulator
# -----------------------------------------------------------------------------
install-simulator() {
    depend xcodebuild install-xcode
    echo "Installing iOS simulator..."
    xcodebuild -downloadPlatform iOS
    xcrun simctl delete all
    xcrun simctl create "iPhone 16" "iPhone 16"
    echo "iOS simulator installation completed."
}

install-docker(){
    depend brew install-homebrew
    brew install --cask docker
}

# Function: setup-folder
# -----------------------------------------------------------------------------
# Set up Dotfiles and Repositories directories and install folderify
#
# Usage:
#   setup-folder
# -----------------------------------------------------------------------------
setup-folder() {
    depend brew install-homebrew
    echo "Setting up folders..."
    mkdir -p ~/Dotfiles
    mkdir -p ~/Repositories

    echo "Installing folderify..."
    brew install folderify

    echo "Creating folderified icons..."
    folderify ~/Downloads/dotfiles.png ~/Dotfiles
    folderify ~/Downloads/repositories.png ~/Repositories

    echo "Folder setup completed."
}

# Main execution
# -----------------------------------------------------------------------------
install-homebrew
install-mysql
install-arc
install-proton-pass
install-mas
install-xcode
install-cocoapods
install-simulator
setup-folder

# echo "Developer environment setup completed."


# brew install chrome-cli
# brew instal --cask docker
# /usr/sbin/softwareupdate --install-rosetta --agree-to-license
# brew install --cask utm

# softwareupdate --install-rosetta --agree-to-license

# install raycast
brew install --cask alt-tab
brew install node

brew install --cask visual-studio-code
code --install-extension chrisdias.vscode-opennewinstance
code --install-extension dart-code.flutter
code --install-extension ivhernandez.vscode-plist
code --install-extension Zwyx.autoclosetabs
code --install-extension github.vscode-github-actions
code --install-extension mishkinf.file-path-commenter

brew install pre-commit
