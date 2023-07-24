#!/bin/bash

set -e  # Exit on any error

# Downloading new zsh bash file and replacing the old one
curl -fsSL https://raw.githubusercontent.com/Cognitive-Agency/bashscripts/main/.zshrc -o ~/.zshrc

# Declaring list of packages with their descriptions
apt update
apt install -y git curl vim htop build-essential software-properties-common apt-transport-https ca-certificates gnupg-agent cmake gnupg nvtop screen git-lfs ffmpeg tree

# Setting up Miniconda
if [ ! -d "$HOME/anaconda3" ]; then
    cd /tmp
    curl -fsSL https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh -o Miniconda3-latest-Linux-x86_64.sh
    bash Miniconda3-latest-Linux-x86_64.sh -b -p $HOME/anaconda3
    rm -f Miniconda3-latest-Linux-x86_64.sh
    grep -qxF 'conda activate base' ~/.zshrc || echo 'conda activate base' >> ~/.zshrc
fi

    # Running the plugins setup script
    curl -fsSL https://raw.githubusercontent.com/Cognitive-Agency/bashscripts/main/setupzsh_plugins.sh -o setupzsh_plugins.sh
    chmod +x setupzsh_plugins.sh 
    ./setupzsh_plugins.sh 
    rm -f setupzsh_plugins.sh 

    # Installing Powerlevel10k theme
    git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ~/.oh-my-zsh/custom/themes/powerlevel10k
    echo 'ZSH_THEME="powerlevel10k/powerlevel10k"' >> ~/.zshrc



