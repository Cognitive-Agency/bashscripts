#!/bin/bash

set -euo pipefail  # Enable bash strict mode

print_message() {
    local msg="$1"
    echo "-----------------------------------"
    echo "$msg"
    echo "-----------------------------------"
}

command_exists() {
    command -v "$1" >/dev/null 2>&1
}

print_error() {
    echo "Error: $1" >&2
    exit 1
}

if ! command_exists curl; then
    print_error "curl is required but it's not installed."
fi  

print_message "Updating and Installing Basic Libraries"

sudo apt update
sudo apt upgrade -y
sudo apt install -y git awscli curl vim htop tmux build-essential zsh software-properties-common apt-transport-https ca-certificates gnupg-agent cmake gnupg nvidia-smi nvtop screen glances parallel 

sudo apt-get update \
    && sudo apt-get install -y nvidia-container-toolkit-base

print_message "Setting up Docker"

# Only proceed with Docker setup if not already installed
if ! command_exists docker; then
    sudo install -m 0755 -d /etc/apt/keyrings
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg

    echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
    $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

    sudo apt update
    sudo apt install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

    # Check if docker group exists before attempting to add it
    if ! getent group docker > /dev/null; then
        sudo groupadd docker
    fi
    sudo usermod -aG docker $USER
    echo "NOTE: Please restart or re-login for Docker group changes to take effect."
else
    echo "Docker is already installed, skipping installation."
fi

print_message "Setting up Miniconda"

# Only proceed with Miniconda setup if not already installed
if [ ! -d "$HOME/anaconda3" ]; then
    pushd /tmp
    wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh
    bash Miniconda3-latest-Linux-x86_64.sh -b -p $HOME/anaconda3
    rm -f Miniconda3-latest-Linux-x86_64.sh 
    popd

    echo "To finish the conda installation, run: source ~/.bashrc && conda --version"
else
    echo "Miniconda is already installed, skipping installation."
fi

print_message "All packages installed!"

print_message "Setting up Oh My Zsh"

# Only proceed with Oh My Zsh setup if not already installed
if [ ! -d "$HOME/.oh-my-zsh" ]; then
    wget https://raw.githubusercontent.com/Cognitive-Agency/bashscripts/main/setupzsh_plugins.sh
    chmod +x setupzsh_plugins.sh

    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
else
    echo "Oh My Zsh is already installed, skipping installation."
fi
