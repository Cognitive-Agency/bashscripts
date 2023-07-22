#!/bin/bash

# Print a message with highlighted borders
print_message() {
    local msg="$1"
    echo "-----------------------------------"
    echo "$msg"
    echo "-----------------------------------"
}

print_message "Updating and Installing Basic Libraries"

# Update the package list and upgrade existing packages
sudo apt update && sudo apt upgrade -y

# Install multiple packages in one go
sudo apt install -y git awscli curl vim htop tmux build-essential zsh software-properties-common apt-transport-https ca-certificates gnupg-agent

print_message "Setting up Oh My Zsh"

# Install Oh My Zsh for managing zsh configuration
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

print_message "Setting up Docker"

# Add Docker official GPG key
sudo mkdir -p /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg-

# Add Docker's repo
echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

sudo apt update

# Install Docker and related tools
sudo apt install -y docker-ce docker-ce-cli containerd.io docker-compose-plugin

# Create the Docker group and add the user to the group
sudo groupadd docker
sudo usermod -aG docker $USER

print_message "Setting up Miniconda"

# Download and install Miniconda
wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh
mkdir -p /root/.conda
bash Miniconda3-latest-Linux-x86_64.sh -b -p $HOME/anaconda3

# Cleanup
rm -f Miniconda3-latest-Linux-x86_64.sh 
echo "To finish the conda installation, run: source ~/.bashrc && conda --version"

print_message "All packages installed!"



