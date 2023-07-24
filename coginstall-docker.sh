#!/bin/bash

set -e  # Exit on any error

print_message() {
    echo -e "\033[1;34m$1\033[0m"  # Print blue text
}

install_package() {
    print_message "Installing $1: $2"
    apt-get install -y $1
}

# Updating System and Installing Basic Libraries
print_message "Updating System and Installing Basic Libraries"
apt-get update
apt-get clean

# Downloading new zsh bash file and replacing the old one
print_message "Downloading new zsh bash file and replacing the old one"
curl -fsSL https://raw.githubusercontent.com/Cognitive-Agency/bashscripts/main/.zshrc -o ~/.zshrc

# Declaring list of packages with their descriptions
declare -A packages=(
    ["git"]="Distributed version control system."
    ["curl"]="Command-line tool for making web requests."
    ["vim"]="Highly configurable text editor."
    ["htop"]="Interactive process viewer for Unix."
    ["build-essential"]="Contains reference libraries for compiling C programs on Ubuntu."
    ["software-properties-common"]="Provides scripts for managing software."
    ["apt-transport-https"]="Allows the package manager to transfer files and data over https."
    ["ca-certificates"]="Common CA certificates for SSL applications."
    ["gnupg-agent"]="GPG agent to handle private keys operations."
    ["cmake"]="Manages the build process in an OS and in a compiler-independent manner."
    ["gnupg"]="For encrypting and signing your data and communication."
    ["nvtop"]="NVIDIA GPUs htop like monitoring tool."
    ["screen"]="Tool for multiplexing several virtual consoles."
    ["git-lfs"]="Git extension for versioning large files."
    ["ffmpeg"]="Multimedia framework for various operations."
    ["tree"]="Displays directories as trees."
)

for pkg in "${!packages[@]}"; do
    install_package "$pkg" "${packages[$pkg]}"
done

# Setting up Miniconda
print_message "Setting up Miniconda"
if [ ! -d "$HOME/anaconda3" ]; then
    cd /tmp
    curl -fsSL https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh -o Miniconda3-latest-Linux-x86_64.sh
    bash Miniconda3-latest-Linux-x86_64.sh -b -p $HOME/anaconda3
    rm -f Miniconda3-latest-Linux-x86_64.sh
    grep -qxF 'conda activate base' ~/.zshrc || echo 'conda activate base' >> ~/.zshrc
fi

# Setting up Oh My Zsh
print_message "Setting up Oh My Zsh"
if [ ! -d "$HOME/.oh-my-zsh" ]; then  
    RUNZSH=no sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

    # Running the plugins setup script
    curl -fsSL https://raw.githubusercontent.com/Cognitive-Agency/bashscripts/main/setupzsh_plugins.sh -o setupzsh_plugins.sh
    chmod +x setupzsh_plugins.sh 
    ./setupzsh_plugins.sh 
    rm -f setupzsh_plugins.sh 

    # Installing Powerlevel10k theme
    git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ~/.oh-my-zsh/custom/themes/powerlevel10k
    echo 'ZSH_THEME="powerlevel10k/powerlevel10k"' >> ~/.zshrc
else
    echo "Oh My Zsh is already installed, skipping installation."  
fi

print_message "Installation complete."


