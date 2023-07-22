# Enhance the PATH variable.
export PATH="$HOME/bin:/usr/local/bin:$PATH:/usr/sbin:/sbin"

# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# Theme configuration.
ZSH_THEME="robbyrussell"

# --------------------------- #
# Completion Configurations   #
# --------------------------- #
# Uncomment the below options if you need them:

# Make completion case-sensitive.
# CASE_SENSITIVE="true"

# Allow hyphen-insensitivity during completion.
# HYPHEN_INSENSITIVE="true"

# ----------------------- #
# Update Configurations   #
# ----------------------- #

# Auto-update behavior for oh-my-zsh.
# Uncomment the below option to enable reminders for updating:
# zstyle ':omz:update' mode reminder

# Configuration for how often to auto-update (in days).
# Uncomment the below option to set the update frequency:
# zstyle ':omz:update' frequency 7

# -------------------------- #
# Plugins Configuration      #
# -------------------------- #

# Make sure you have installed all these plugins.
# If not, you might need to clone their respective repositories 
# into the $ZSH_CUSTOM/plugins/ directory.
plugins=(
    git
    zsh-autosuggestions
    zsh-syntax-highlighting
    zsh-completions
    fast-syntax-highlighting
    zsh-interactive-cd
    fzf-tab
    zsh-z
)

# Source oh-my-zsh to load the framework.
source $ZSH/oh-my-zsh.sh

# ------------------- #
# User Configuration  #
# ------------------- #

# Uncomment below line to set language:
# export LANG=en_US.UTF-8

# Set the default editor to vim.
export EDITOR='vim'

# ----------------- #
# Personal Aliases  #
# ----------------- #
# User configuration ...

PROMPT="%n@%m %~ %># "

# Personal aliases ...
alias zshconfig="vim ~/.zshrc"
alias ohmyzsh="cd ~/.oh-my-zsh"
alias ll="ls -alF"
alias la="ls -A"
alias l="ls -CF"

# End of the .zshrc file.
