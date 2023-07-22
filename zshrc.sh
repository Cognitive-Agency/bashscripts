# Enhance the PATH variable.
export PATH=$HOME/bin:/usr/local/bin:$PATH:/usr/sbin:/sbin

# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# Theme configuration.
ZSH_THEME="robbyrussell"
# ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )

# Completion configurations.
# CASE_SENSITIVE="true"
# HYPHEN_INSENSITIVE="true"

# Auto-update behavior for oh-my-zsh.
# zstyle ':omz:update' mode reminder

# Configuration for how often to auto-update (in days).
# zstyle ':omz:update' frequency 7

# Other configurations (commented out for now).
# DISABLE_MAGIC_FUNCTIONS="true"
# DISABLE_LS_COLORS="true"
# DISABLE_AUTO_TITLE="true"
# ENABLE_CORRECTION="true"
# COMPLETION_WAITING_DOTS="true"
# DISABLE_UNTRACKED_FILES_DIRTY="true"
# HIST_STAMPS="mm/dd/yyyy"

# Custom folder for oh-my-zsh.
# ZSH_CUSTOM=/path/to/new-custom-folder

# Plugins to load. All the plugins from the provided script.
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

# Source oh-my-zsh.
source $ZSH/oh-my-zsh.sh

# User configuration.

# Set language.
# export LANG=en_US.UTF-8

# Set the default editor.
export EDITOR='vim'

# Set compilation flags.
# export ARCHFLAGS="-arch x86_64"

# Personal aliases.
alias zshconfig="vim ~/.zshrc"
alias ohmyzsh="cd ~/.oh-my-zsh"
alias ll="ls -alF"
alias la="ls -A"
alias l="ls -CF"

