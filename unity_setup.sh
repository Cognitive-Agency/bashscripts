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

# Check for essential commands
for cmd in curl wget sudo dpkg getent; do
    if ! command_exists "$cmd"; then
        print_error "$cmd is required but it's not installed."
    fi
done

# Ensure snap is installed
if ! command_exists snap; then
    print_message "Installing snap..."
    sudo apt install -y snapd
else
    echo "snap is already installed."
fi

# Check if snapd is active, if not wait and check again
while ! systemctl is-active --quiet snapd; do
    echo "Waiting for snapd service to start..."
    sleep 2
done

# Install common utilities and libraries.
print_message "Updating System and Installing Basic Libraries"

sudo apt update
sudo apt upgrade -y

install_package() {
    print_message "Installing $1: $2"
    sudo apt install -y $1
}

# List of packages to install
packages=(
    "git" "Distributed version control system."
    "awscli" "Command-line interface for interacting with AWS services."
    "curl" "Command-line tool for making web requests."
    "vim" "Highly configurable text editor."
    "htop" "Interactive process viewer for Unix."
    "tmux" "Terminal multiplexer for managing multiple terminal sessions."
    "build-essential" "Contains reference libraries for compiling C programs on Ubuntu."
    "software-properties-common" "Provides scripts for managing software."
    "apt-transport-https" "Allows the package manager to transfer files and data over https."
    "ca-certificates" "Common CA certificates for SSL applications."
    "gnupg-agent" "GPG agent to handle private keys operations."
    "cmake" "Manages the build process in an OS and in a compiler-independent manner."
    "gnupg" "For encrypting and signing your data and communication."
    "screen" "Tool for multiplexing several virtual consoles."
    "glances" "Cross-platform monitoring tool."
    "parallel" "Shell tool for executing jobs in parallel."
    "git-lfs" "Git extension for versioning large files."
    "ffmpeg" "Multimedia framework for various operations."
    "bash-completion" "Programmable completion for bash commands."
    "tldr" "Community-driven man pages."
    "fzf" "Command-line fuzzy finder."
    "ncdu" "Disk usage analyzer with ncurses interface."
    "jq" "Command-line JSON processor."
    "tree" "Displays directories as trees."
    "tmate" "Instant terminal sharing."
    "bat" "Cat clone with syntax highlighting."
    "ripgrep" "Ultra-fast text searcher."
    "neofetch" "System info written in Bash."
    "iproute2" "Network tools."
)

# Install packages
for ((i=0; i<${#packages[@]}; i+=2)); do
    install_package "${packages[i]}" "${packages[i+1]}"
done

sudo apt-get install -y cargo

sudo snap install lsd

print_message "Setting up Docker"
if ! command_exists docker; then
    sudo install -m 0755 -d /etc/apt/keyrings
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg

    echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
    $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

    sudo apt update
    sudo apt install -y docker-ce docker-ce-cli containerd.io

    if ! getent group docker > /dev/null; then
        sudo groupadd docker
    fi
    sudo usermod -aG docker $USER
    echo "NOTE: Please restart or re-login for Docker group changes to take effect."
else
    echo "Docker is already installed, skipping installation."
fi

# Conda installation and path setup
print_message "Setting up Miniconda"
if [ ! -d "$HOME/anaconda3" ]; then
    pushd /tmp
    wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh
    bash Miniconda3-latest-Linux-x86_64.sh -b -p $HOME/anaconda3
    popd

    echo 'export PATH="$HOME/anaconda3/bin:$PATH"' >> ~/.bashrc
    echo 'conda activate base' >> ~/.bashrc
else
    echo "Miniconda is already installed, skipping installation."
fi

# Wait for Docker to be ready
while ! sudo docker info >/dev/null 2>&1; do
    echo "Waiting for Docker to start..."
    sleep 10
done

# Echo before pulling Docker images
echo "Pulling Docker images..."

sudo docker pull python:3.9-slim  # Pull a basic Python image

echo -e "\rDocker images pulled successfully."

print_message "Installation Summary:"
echo "1. Updated the system and installed basic libraries."
echo "2. Installed snap tool."
echo "3. Set up Docker."
echo "4. Installed Miniconda."
echo "5. Pulled a basic Python Docker image."
echo "Please review any notes or warnings provided during the installation process."

echo "Installation complete. Please reboot your system to ensure all changes take effect."
