#!/bin/bash

# This script sets up a Unix system with various tools and libraries.
# It has safeguards such as bash strict mode to prevent potential issues.

set -euo pipefail  # Enable bash strict mode
trap "echo 'Script interrupted by user'; exit 1" INT

print_message() {
    echo -e "\033[1;34m$1\033[0m"
}

command_exists() {
    command -v "$1" >/dev/null 2>&1
}

print_error() {
    echo "Error: $1" >&2
    exit 1
}

# Check for essential commands
for cmd in curl wget sudo dpkg getent; do
    if ! command_exists "$cmd"; then
        print_error "$cmd is required but it's not installed."
    fi
done

# Install common utilities and libraries.
# Each installation step provides a short description for clarity.
print_message "Updating System and Installing Basic Libraries"

sudo apt update
sudo apt upgrade -y

install_package() {
    print_message "Installing $1: $2"
    sudo apt install -y $1
}

install_package git "Distributed version control system."
install_package awscli "Command-line interface for interacting with AWS services."
install_package curl "Command-line tool for making web requests."
install_package vim "Highly configurable text editor."
install_package htop "Interactive process viewer for Unix."
install_package tmux "Terminal multiplexer for managing multiple terminal sessions."
install_package build-essential "Contains reference libraries for compiling C programs on Ubuntu."
install_package zsh "Z shell - an extended Bourne shell with numerous improvements."
install_package software-properties-common "Provides scripts for managing software."
install_package apt-transport-https "Allows the package manager to transfer files and data over https."
install_package ca-certificates "Common CA certificates for SSL applications."
install_package gnupg-agent "GPG agent to handle private keys operations."
install_package cmake "Manages the build process in an OS and in a compiler-independent manner."
install_package gnupg "For encrypting and signing your data and communication."
install_package nvtop "NVIDIA GPUs htop like monitoring tool."
install_package screen "Tool for multiplexing several virtual consoles."
install_package glances "Cross-platform monitoring tool."
install_package parallel "Shell tool for executing jobs in parallel."
install_package git-lfs "Git extension for versioning large files."
install_package ffmpeg "Multimedia framework for various operations."
install_package bash-completion "Programmable completion for bash commands."
install_package silversearcher-ag "Ultra-fast text searcher."
install_package tldr "Community-driven man pages."
install_package fzf "Command-line fuzzy finder."
install_package ncdu "Disk usage analyzer with ncurses interface."
install_package jq "Command-line JSON processor."
install_package tree "Displays directories as trees."
install_package tmate "Instant terminal sharing."
install_package byobu "Text-based window manager and terminal multiplexer."
install_package ranger "Console file manager with vi-like keybinding."
install_package bat "Cat clone with syntax highlighting."
install_package ripgrep "Ultra-fast text searcher."
install_package neofetch "System info written in Bash."
install_package mc "Visual file manager."
install_package iproute2 "Network tools."

sudo snap install lsd


print_message "Installing Starship prompt"
curl -sS https://starship.rs/install.sh | bash

print_message "Setting up Docker"
# Set up Docker only if it isn't already installed.
if ! command_exists docker; then
    sudo install -m 0755 -d /etc/apt/keyrings
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg

    echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
    $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

    sudo apt update
    sudo apt install -y docker-ce docker-ce-cli containerd.io

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
if [ ! -d "$HOME/anaconda3" ]; then
    pushd /tmp
    wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh
    bash Miniconda3-latest-Linux-x86_64.sh -b -p $HOME/anaconda3
    rm -f Miniconda3-latest-Linux-x86_64.sh 
    popd

    # These commands are appending the string "conda activate base" to the respective shell configuration files
    echo "conda activate base" >> ~/.bashrc
    echo "conda activate base" >> ~/.zshrc

    echo "To finish the conda installation, run: source ~/.bashrc && conda --version"
else
    echo "Miniconda is already installed, skipping installation."
fi

# Setting up NVIDIA Toolkit for GPU-accelerated container support.
print_message "Setting up NVIDIA Toolkit"
distribution=$(. /etc/os-release;echo $ID$VERSION_ID) \
        && curl -fsSL https://nvidia.github.io/libnvidia-container/gpgkey | sudo gpg --dearmor -o /usr/share/keyrings/nvidia-container-toolkit-keyring.gpg \
        && curl -s -L https://nvidia.github.io/libnvidia-container/$distribution/libnvidia-container.list | \
            sed 's#deb https://#deb [signed-by=/usr/share/keyrings/nvidia-container-toolkit-keyring.gpg] https://#g' | \
            sudo tee /etc/apt/sources.list.d/nvidia-container-toolkit.list

sudo apt update
sudo apt-get install -y nvidia-container-toolkit
sudo nvidia-ctk runtime configure --runtime=docker
sudo systemctl restart docker

# Wait for Docker to be ready
while ! sudo docker info >/dev/null 2>&1; do
    echo "Waiting for Docker to start..."
    sleep 2
done

# Echo before pulling Docker images
echo "Pulling Docker images..."

#Pull Docker Images
sudo docker pull nvidia/cuda:11.1.1-devel-ubuntu20.04
sudo docker pull nvcr.io/nvidia/pytorch:23.05-py3
sudo docker pull mosaicml/pytorch:1.13.1_cu117-python3.10-ubuntu20.04
sudo docker pull bitnami/deepspeed
sudo docker pull nvcr.io/nvidia/nemo:23.04

#Install Helm
# Helm helps manage Kubernetes applications with 'helm charts'.
print_message "Installing Helm"
curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3
chmod 700 get_helm.sh
./get_helm.sh
rm -f get_helm.sh

# Clone various git repositories for training, techniques, models, and user interface.
# Organize them into respective directories.

#install git repositories
mkdir -p ~/projects
cd ~/projects

#training 
mkdir -p training
cd training
git clone https://github.com/mosaicml/composer.git mosaic-composer
git clone https://github.com/mosaicml/llm-foundry.git mosiac-foundry
git clone https://github.com/microsoft/DeepSpeed.git deepspeed
git clone https://github.com/openai/triton.git openai-triton
cd ..

#techniques
mkdir -p techniques
cd techniques
git clone https://github.com/vllm-project/vllm.git vllm 
git clone https://github.com/openai/tiktoken.git tiktoken
git clone https://github.com/TimDettmers/bitsandbytes.git bitsandbytes
git clone https://github.com/huggingface/peft.git PEFT
git clone https://github.com/microsoft/LoRA.git Lora
cd ..

#models
mkdir -p models
cd models
git clone https://github.com/facebookresearch/llama.git llama
git clone https://github.com/EleutherAI/gpt-neox.git gpt-neox
git clone https://github.com/microsoft/JARVIS.git jarvis
git clone https://github.com/triton-inference-server/server.git triton-server
git clone https://github.com/ShishirPatil/gorilla.git gorilla-llm
git clone https://github.com/openai/openai-cookbook.git openai-cookbook
cd ..

#user interface
mkdir -p "user interface"
cd "user interface"
git clone https://github.com/mckaywrigley/chatbot-ui.git chatbot-user-interface
git clone https://github.com/mlc-ai/web-llm.git web-interface
git clone https://github.com/openai/chatgpt-retrieval-plugin.git chatgpt-retrieval
git clone https://github.com/lm-sys/FastChat.git FastChat
git clone https://github.com/deepset-ai/haystack.git haystack

print_message "Setting up Oh My Zsh"
if [ ! -d "$HOME/.oh-my-zsh" ]; then
    # Install Oh My Zsh first
    RUNZSH=no sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

    # Now run the plugins setup script
    wget https://raw.githubusercontent.com/Cognitive-Agency/bashscripts/main/setupzsh_plugins.sh
    chmod +x setupzsh_plugins.sh
    ./setupzsh_plugins.sh
    rm -f setupzsh_plugins.sh  # Cleanup the setup script
else
    echo "Oh My Zsh is already installed, skipping installation."
fi


