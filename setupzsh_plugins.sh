#!/bin/bash

set -euo pipefail  # Enable bash strict mode

# Print a message with highlighted borders
print_message() {
    local msg="$1"
    echo "-----------------------------------"
    echo "$msg"
    echo "-----------------------------------"
}

# Check if a command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Check if a plugin is already installed
plugin_installed() {
    [ -d "${ZSH_CUSTOM}/plugins/$1" ]
}

# Append plugin to zshrc if not present
append_plugin_to_zshrc() {
    local plugin_name="$1"
    if ! grep -q " $plugin_name " ~/.zshrc; then
        sed -i.bak "/plugins=(/ s/)/ $plugin_name )/" ~/.zshrc
    fi
}

print_message "Installing Tools"

# Install essential tools
sudo apt update
sudo apt install -y jq fzf bat ripgrep tmux ncdu htop

print_message "Setting up Zsh Plugins"

# Define the location of the Oh My Zsh installation
ZSH_CUSTOM="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"

declare -A plugins
plugins=(
    ["zsh-autosuggestions"]="https://github.com/zsh-users/zsh-autosuggestions"
    ["zsh-syntax-highlighting"]="https://github.com/zsh-users/zsh-syntax-highlighting.git"
    ["zsh-completions"]="https://github.com/zsh-users/zsh-completions"
    ["fast-syntax-highlighting"]="https://github.com/zdharma/fast-syntax-highlighting.git"
    ["zsh-interactive-cd"]="https://github.com/changyuheng/zsh-interactive-cd"
    ["fzf-tab"]="https://github.com/Aloxaf/fzf-tab"
    ["zsh-z"]="https://github.com/agkozak/zsh-z"
)

for plugin in "${!plugins[@]}"; do
    if ! plugin_installed $plugin; then
        git clone ${plugins[$plugin]} ${ZSH_CUSTOM}/plugins/$plugin
        append_plugin_to_zshrc $plugin
        echo "$plugin has been installed and added to ~/.zshrc"
    else
        echo "$plugin is already installed."
    fi
done

print_message "All installations complete!"
