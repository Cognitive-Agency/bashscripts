#!/bin/bash

# This script sets up a Unix system with various tools and libraries.
# It has safeguards such as bash strict mode to prevent potential issues.

set -euo pipefail  # Enable bash strict mode
trap "echo 'Script interrupted by user'; exit 1" INT  # Trap Ctrl-C

print_message() {
    echo -e "\033[1;34m$1\033[0m"  # Print blue text
}

command_exists() {
    command -v "$1" >/dev/null 2>&1  # Check if command exists
}

print_error() {
    echo "Error: $1" >&2  # Print error message to stderr
    exit 1
}

spin() {
    local -a spinner=('|' '/' '-' '\')  # Spinner characters
    while true; do
        for i in "${spinner[@]}"; do
            echo -ne "\r$i"
            sleep 0.2
        done
    done
}

#Download new bash file and replace old one
print_message "Download new bash file and replace old one"
wget https://raw.githubusercontent.com/Cognitive-Agency/bashscripts/main/.bashrc -O ~/.bashrc
source ~/.bashrc

#Download new zsh bash file file and replace old one
print_message "Download new zsh bash file and replace old one"
wget https://raw.githubusercontent.com/Cognitive-Agency/bashscripts/main/.zshrc -O ~/.zshrc

# Check for essential commands
for cmd in curl wget sudo dpkg getent; do  # List of commands to check
    if ! command_exists "$cmd"; then   # Check if command exists
        print_error "$cmd is required but it's not installed."   # Print error message
    fi
done

# Ensure snap is installed
if ! command_exists snap; then
    print_message "Installing snap..."
    sudo apt install -y snapd  # Install snap
else
    echo "snap is already installed."
fi

# Check if snapd is active, if not wait and check again
while ! systemctl is-active --quiet snapd; do
    echo "Waiting for snapd service to start..."
    sleep 2
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

install_package git "Distributed version control system."  # Distributed version control system
install_package awscli "Command-line interface for interacting with AWS services."  # Command-line interface for interacting with AWS services
install_package curl "Command-line tool for making web requests."  # Command-line tool for making web requests
install_package vim "Highly configurable text editor."  # Highly configurable text editor
install_package htop "Interactive process viewer for Unix."  # Interactive process viewer for Unix
install_package tmux "Terminal multiplexer for managing multiple terminal sessions."  # Terminal multiplexer for managing multiple terminal sessions
install_package build-essential "Contains reference libraries for compiling C programs on Ubuntu."  # Contains reference libraries for compiling C programs on Ubuntu
install_package zsh "Z shell - an extended Bourne shell with numerous improvements."  # Z shell - an extended Bourne shell with numerous improvements
install_package software-properties-common "Provides scripts for managing software."  # Provides scripts for managing software
install_package apt-transport-https "Allows the package manager to transfer files and data over https."  # Allows the package manager to transfer files and data over https
install_package ca-certificates "Common CA certificates for SSL applications."  # Common CA certificates for SSL applications
install_package gnupg-agent "GPG agent to handle private keys operations."  # GPG agent to handle private keys operations
install_package cmake "Manages the build process in an OS and in a compiler-independent manner."  # CMake is a cross-platform free and open-source software tool for managing the build process of software using a compiler-independent method.
install_package gnupg "For encrypting and signing your data and communication."  # GNU Privacy Guard
install_package nvtop "NVIDIA GPUs htop like monitoring tool."  # NVIDIA GPUs htop like monitoring tool
install_package screen "Tool for multiplexing several virtual consoles."  # Screen is a terminal multiplexer
install_package glances "Cross-platform monitoring tool."  # Cross-platform monitoring tool
install_package parallel "Shell tool for executing jobs in parallel."  # Shell tool for executing jobs in parallel
install_package git-lfs "Git extension for versioning large files."  # Git extension for versioning large files
install_package ffmpeg "Multimedia framework for various operations."  # Multimedia framework for various operations
install_package bash-completion "Programmable completion for bash commands."  # Programmable completion for bash commands
install_package silversearcher-ag "Ultra-fast text searcher."  # ag is faster than grep
install_package tldr "Community-driven man pages."   
install_package fzf "Command-line fuzzy finder."  # Command-line fuzzy finder
install_package ncdu "Disk usage analyzer with ncurses interface."  # Disk usage analyzer with ncurses interface
install_package jq "Command-line JSON processor."  # Command-line JSON processor
install_package tree "Displays directories as trees."  # Displays directories as trees
install_package tmate "Instant terminal sharing."  # tmate is a fork of tmux
install_package byobu "Text-based window manager and terminal multiplexer."  # Byobu is a wrapper for tmux or screen
install_package ranger "Console file manager with vi-like keybinding."  # Console file manager with vi-like keybinding
install_package bat "Cat clone with syntax highlighting."  # Cat clone with syntax highlighting
install_package ripgrep "Ultra-fast text searcher."  # ripgrep is faster than ag
install_package neofetch "System info written in Bash."  # System info written in Bash
install_package mc "Visual file manager."  # Midnight Commander
install_package iproute2 "Network tools."  # ip command
install_package autojump " #autojump is a faster way to navigate your filesystem. It works by maintaining a database of the directories you use the most from the command line."

sudo snap install lsd  

# Install Starship 
sudo snap install --edge starship

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
grep -qxF 'conda activate base' ~/.bashrc || echo 'conda activate base' >> ~/.bashrc
grep -qxF 'conda activate base' ~/.zshrc || echo 'conda activate base' >> ~/.zshrc

    echo "To finish the conda installation, run: source ~/.bashrc && conda --version"
else
    echo "Miniconda is already installed, skipping installation."
fi

# Installing CUDA Drivers **NOTE VERSION 11.8**"
print_message "Installing CUDA Toolkit - **NOTE VERSION 11.8"
wget https://developer.download.nvidia.com/compute/cuda/repos/ubuntu2004/x86_64/cuda-ubuntu2004.pin  # Download CUDA pin file
sudo mv cuda-ubuntu2004.pin /etc/apt/preferences.d/cuda-repository-pin-600  # Move pin file to apt preferences directory
wget https://developer.download.nvidia.com/compute/cuda/11.8.0/local_installers/cuda-repo-ubuntu2004-11-8-local_11.8.0-520.61.05-1_amd64.deb  # Download CUDA deb file
sudo dpkg -i cuda-repo-ubuntu2004-11-8-local_11.8.0-520.61.05-1_amd64.deb  # Install CUDA deb file
sudo cp /var/cuda-repo-ubuntu2004-11-8-local/cuda-*-keyring.gpg /usr/share/keyrings/  # Copy CUDA keyring to keyrings directory
sudo apt-get update  # Update the list of packages
sudo apt-get -y install cuda  # Install CUDA Toolkit

# Setting up NVIDIA Toolkit for GPU-accelerated container support.
print_message "Setting up NVIDIA Toolkit"
distribution=$(. /etc/os-release;echo $ID$VERSION_ID) \  # Get the distribution name
        && curl -fsSL https://nvidia.github.io/libnvidia-container/gpgkey | sudo gpg --dearmor -o /usr/share/keyrings/nvidia-container-toolkit-keyring.gpg \  # Download keyring
        && curl -s -L https://nvidia.github.io/libnvidia-container/$distribution/libnvidia-container.list | \  # Download list file
            sed 's#deb https://#deb [signed-by=/usr/share/keyrings/nvidia-container-toolkit-keyring.gpg] https://#g' | \  # Replace https with https [signed-by=...] in the list file
            sudo tee /etc/apt/sources.list.d/nvidia-container-toolkit.list  # Write the list file to the sources.list.d directory

sudo apt update  # Update the list of packages
sudo apt-get install -y nvidia-container-toolkit  # Install NVIDIA Toolkit
sudo nvidia-ctk runtime configure --runtime=docker  # Configure Docker to use NVIDIA Toolkit
sudo systemctl restart docker  # Restart Docker

# Clean up CUDA installation as done with MiniConda
print_message "Cleaning up CUDA installation files..."  # Clean up CUDA installation files
rm -f cuda-repo-ubuntu2004-11-8-local_11.8.0-520.61.05-1_amd64.deb  # Remove CUDA deb file

# Check if the CUDA bin directory is already in the PATH
if [[ ":$PATH:" != *":/usr/local/cuda-11.8/bin:"* ]]; then  # Check if CUDA bin directory is already in the PATH
    echo "Adding CUDA to the system PATH..."       

# Add CUDA bin directory to PATH for the current session
export PATH=$PATH:/usr/local/cuda-11.8/bin  # Add CUDA bin directory to PATH for the current session

# Make this change permanent by adding it to ~/.bashrc and ~/.zshrc (if you use Zsh)
echo 'export PATH=$PATH:/usr/local/cuda-11.8/bin' >> ~/.bashrc  # Add CUDA bin directory to PATH for future sessions
    [[ -f ~/.zshrc ]] && echo 'export PATH=$PATH:/usr/local/cuda-11.8/bin' >> ~/.zshrc  # Add CUDA bin directory to PATH for future sessions
fi

# Wait for Docker to be ready
while ! sudo docker info >/dev/null 2>&1; do
    echo "Waiting for Docker to start..."
    sleep 10  # Wait 10 seconds before checking again  
done

# Echo before pulling Docker images
echo "Pulling Docker images..."
spin &  # Start the spinner in the background
SPIN_PID=$!

sudo docker pull nvcr.io/nvidia/pytorch:23.05-py3  # Pull PyTorch image

kill -9 $SPIN_PID  # Kill the spinner after the images have been pulled
echo -e "\rDocker images pulled successfully.          "

trap "kill -9 $SPIN_PID" EXIT  # Ensure spinner stops when the script exits

print_message "Setting up Oh My Zsh"
if [ ! -d "$HOME/.oh-my-zsh" ]; then  
    # Install Oh My Zsh first  
    RUNZSH=no sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"  # Install Oh My Zsh

    # Now run the plugins setup script
    wget https://raw.githubusercontent.com/Cognitive-Agency/bashscripts/main/setupzsh_plugins.sh  # Download the setup script
    chmod +x setupzsh_plugins.sh  # Make the setup script executable
    ./setupzsh_plugins.sh  # Run the setup script
    rm -f setupzsh_plugins.sh  # Cleanup the setup script

      # Install Powerlevel10k theme
sudo git clone --depth=1 https://github.com/romkatv/powerlevel10k.git $ZSH_CUSTOM/themes/powerlevel10k
source ~/.zshrc


else
    echo "Oh My Zsh is already installed, skipping installation."  
fi

print_message "Installation Summary:"
echo "1. Updated the system and installed basic libraries."
echo "2. Installed snap tool."
echo "3. Set up Docker."
echo "4. Installed Miniconda."
echo "5. Installed CUDA Toolkit version 11.8."
echo "6. Set up NVIDIA Toolkit."
echo "7. Installed Oh My Zsh and its plugins."
echo "Please review any notes or warnings provided during the installation process."