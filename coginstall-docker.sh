#!/bin/bash

set -euo pipefail  # Enable bash strict mode
trap "echo 'Script interrupted by user'; exit 1" INT  # Trap Ctrl-C

print_message() {
    echo -e "\033[1;34m$1\033[0m"  # Print blue text
}

command_exists() {
    command -v "$1" >/dev/null 2>&1  # Check if command exists
}

# No need for sudo as Docker runs as root
install_package() {
    print_message "Installing $1: $2"
    apt install -y $1
}

# Download and replace zsh bash file
print_message "Download new zsh bash file and replace old one"    
wget https://raw.githubusercontent.com/Cognitive-Agency/bashscripts/main/.zshrc -O ~/.zshrc  

# Install common utilities and libraries
print_message "Updating System and Installing Basic Libraries"
apt update
apt upgrade -y

# List of packages with their descriptions
declare -A packages=(
    ["git"]="Distributed version control system."
    ["awscli"]="Command-line interface for interacting with AWS services."
    ["curl"]="Command-line tool for making web requests."
    ["vim"]="Highly configurable text editor."
    ["htop"]="Interactive process viewer for Unix."
    ["tmux"]="Terminal multiplexer for managing multiple terminal sessions."
    ["build-essential"]="Contains reference libraries for compiling C programs on Ubuntu."
    ["zsh"]="Z shell - an extended Bourne shell with numerous improvements."
    ["software-properties-common"]="Provides scripts for managing software."
    ["apt-transport-https"]="Allows the package manager to transfer files and data over https."
    ["ca-certificates"]="Common CA certificates for SSL applications."
    ["gnupg-agent"]="GPG agent to handle private keys operations."
    ["cmake"]="Manages the build process in an OS and in a compiler-independent manner."
    ["gnupg"]="For encrypting and signing your data and communication."
    ["nvtop"]="NVIDIA GPUs htop like monitoring tool."
    ["screen"]="Tool for multiplexing several virtual consoles."
    ["glances"]="Cross-platform monitoring tool."
    ["parallel"]="Shell tool for executing jobs in parallel."
    ["git-lfs"]="Git extension for versioning large files."
    ["ffmpeg"]="Multimedia framework for various operations."
    ["tree"]="Displays directories as trees."
)

for pkg in "${!packages[@]}"; do
    install_package "$pkg" "${packages[$pkg]}"
done

print_message "Setting up Miniconda"
if [ ! -d "$HOME/anaconda3" ]; then
    pushd /tmp
    wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh
    bash Miniconda3-latest-Linux-x86_64.sh -b -p $HOME/anaconda3
    rm -f Miniconda3-latest-Linux-x86_64.sh 
    popd
    grep -qxF 'conda activate base' ~/.zshrc || echo 'conda activate base' >> ~/.zshrc
else
    echo "Miniconda is already installed, skipping installation."
fi

print_message "Setting up Oh My Zsh"
if [ ! -d "$HOME/.oh-my-zsh" ]; then  
    RUNZSH=no sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" 

    # Now run the plugins setup script
    wget https://raw.githubusercontent.com/Cognitive-Agency/bashscripts/main/setupzsh_plugins.sh 
    chmod +x setupzsh_plugins.sh 
    ./setupzsh_plugins.sh 
    rm -f setupzsh_plugins.sh 

    # Install Powerlevel10k theme
    git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ~/.oh-my-zsh/custom/themes/powerlevel10k
    echo 'ZSH_THEME="powerlevel10k/powerlevel10k"' >> ~/.zshrc
else
    echo "Oh My Zsh is already installed, skipping installation."  
fi

print_message "Installation complete."
