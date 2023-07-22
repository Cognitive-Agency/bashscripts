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

# Check for essential commands
for cmd in curl wget sudo; do
    if ! command_exists "$cmd"; then
        print_error "$cmd is required but it's not installed."
    fi
done

print_message "Updating and Installing Basic Libraries"

# Merging the apt and apt-get commands for consistency
sudo apt update
sudo apt upgrade -y
sudo apt install -y git awscli curl vim htop tmux build-essential zsh software-properties-common apt-transport-https ca-certificates gnupg-agent cmake gnupg nvtop screen glances parallel git-lfs ffmpeg

print_message "Setting up Docker"

# Only proceed with Docker setup if not already installed
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

#Pull Docker Images
sudo docker pull nvidia/cuda:11.6.2-base-ubuntu20.04 nvidia-smi
sudo docker pull nvcr.io/nvidia/pytorch:23.05-py3
sudo docker pull mosaicml/pytorch:1.13.1_cu117-python3.10-ubuntu20.04
sudo docker pull bitnami/deepspeed
sudo docker pull nvcr.io/nvidia/nemo:23.04

#Install Helm
curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3
chmod 700 get_helm.sh
./get_helm.sh

print_message "Setting up Oh My Zsh"

# Only proceed with Oh My Zsh setup if not already installed
if [ ! -d "$HOME/.oh-my-zsh" ]; then
    wget https://raw.githubusercontent.com/Cognitive-Agency/bashscripts/main/setupzsh_plugins.sh
    chmod +x setupzsh_plugins.sh
    ./setupzsh_plugins.sh  # Running the downloaded script

    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
    rm -f setupzsh_plugins.sh  # Cleanup the setup script
else
    echo "Oh My Zsh is already installed, skipping installation."
fi
