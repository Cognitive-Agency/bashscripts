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

# Error handling function
check_command_success() {
    if [ $? -ne 0 ]; then
        echo "Error: Command failed!"
        exit 1
    fi
}

# Ensure curl is installed
if ! command_exists curl; then
    echo "curl is required but it's not installed. Exiting."
    exit 1
fi

print_message "Updating and Installing Basic Libraries"

# Update the package list and upgrade existing packages
sudo apt update && sudo apt upgrade -y
check_command_success

# Install multiple packages in one go
sudo apt install -y git awscli curl vim htop tmux build-essential zsh software-properties-common apt-transport-https ca-certificates gnupg-agent cmake gnupg
check_command_success

print_message "Setting up Docker"

# Add Docker official GPG key
sudo install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
check_command_success

# Add Docker's repo
echo \
  "deb [arch="$(dpkg --print-architecture)" signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  "$(. /etc/os-release && echo "$VERSION_CODENAME")" stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

sudo apt-get update
check_command_success

# Install Docker and related tools
sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
check_command_success

# Create the Docker group and add the user to the group
sudo groupadd docker || echo "Docker group already exists."
sudo usermod -aG docker $USER
check_command_success
echo "NOTE: Please restart or re-login for Docker group changes to take effect."

print_message "Setting up Miniconda"

# Download and install Miniconda
pushd /tmp  # Switch to the /tmp directory
wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh
check_command_success

mkdir -p /root/.conda
bash Miniconda3-latest-Linux-x86_64.sh -b -p $HOME/anaconda3
check_command_success

# Cleanup
rm -f Miniconda3-latest-Linux-x86_64.sh 
popd  # Return to the original directory

echo "To finish the conda installation, run: source ~/.bashrc && conda --version"
check_command_success

print_message "All packages installed!"

print_message "Setting up Oh My Zsh"

# Install Oh My Zsh for managing zsh configuration
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
check_command_success



