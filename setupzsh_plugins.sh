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
    local plugin_string="plugins=("
    local zshrc_content=$(<~/.zshrc)

    if [[ ! $zshrc_content =~ $plugin_name ]]; then
        local updated_content=${zshrc_content/$plugin_string/$plugin_string$'\n   '"$plugin_name"}
        echo "$updated_content" > ~/.zshrc
    fi
}

print_message "Setting up Zsh Plugins"

# Define the location of the Oh My Zsh installation
ZSH_CUSTOM="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"

declare -A plugins
plugins=(
    ["zsh-autosuggestions"]="https://github.com/zsh-users/zsh-autosuggestions"
    ["zsh-syntax-highlighting"]="https://github.com/zsh-users/zsh-syntax-highlighting.git"
    
    ["zsh-interactive-cd"]="https://github.com/changyuheng/zsh-interactive-cd"
    ["fzf-tab"]="https://github.com/Aloxaf/fzf-tab"
    ["zsh-z"]="https://github.com/agkozak/zsh-z"
    # You can add more plugins here following the same format
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


