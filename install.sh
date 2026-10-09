
#!/bin/bash

set -euo pipefail

echo "===================================="
echo " macOS Workstation Setup"
echo "===================================="

# Ensure the script is running on macOS.
if [[ "$(uname)" != "Darwin" ]]; then
    echo "Error: This installer only supports macOS."
    exit 1
fi

# Install Apple's command-line developer tools if needed.
if ! xcode-select -p >/dev/null 2>&1; then
    echo "Install Xcode Command Line Tools first:"
    echo "xcode-select --install"
    exit 1
fi

# Install Homebrew if missing.
if ! command -v brew >/dev/null 2>&1; then
    echo "Installing Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

# Configure Homebrew for Apple Silicon or Intel Macs.
if [[ -x /opt/homebrew/bin/brew ]]; then
    eval "$(/opt/homebrew/bin/brew shellenv)"
elif [[ -x /usr/local/bin/brew ]]; then
    eval "$(/usr/local/bin/brew shellenv)"
else
    echo "Error: Homebrew installation could not be located."
    exit 1
fi

# Install packages declared in the Brewfile beside this script.
SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"

echo "Updating Homebrew..."
brew update

echo "Installing workstation packages..."
brew bundle --file="$SCRIPT_DIR/Brewfile"

# Install and activate Node.js LTS through nvm.
export NVM_DIR="${NVM_DIR:-$HOME/.nvm}"
mkdir -p "$NVM_DIR"

NVM_SCRIPT="$(brew --prefix nvm)/nvm.sh"

if [[ ! -s "$NVM_SCRIPT" ]]; then
    echo "Error: nvm was installed but nvm.sh was not found."
    exit 1
fi

# Load nvm for this installer session.
. "$NVM_SCRIPT"

echo "Installing Node.js LTS..."
nvm install --lts
nvm use --lts

# Configure nvm for future zsh sessions.
ZSHRC="$HOME/.zshrc"
NVM_CONFIG='export NVM_DIR="$HOME/.nvm"
[ -s "$(brew --prefix nvm)/nvm.sh" ] && . "$(brew --prefix nvm)/nvm.sh"'

touch "$ZSHRC"

if ! grep -q 'NVM_DIR=.*\.nvm' "$ZSHRC"; then
    printf '\n# Node Version Manager (nvm)\n%s\n' "$NVM_CONFIG" >> "$ZSHRC"
fi

echo ""
echo "Running workstation verification..."
"$SCRIPT_DIR/verify.sh"

echo ""
echo "Workstation setup completed."
echo "Open a new terminal after installation."
