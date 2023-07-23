# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# Enhance the PATH variable.
export PATH="$HOME/bin:/usr/local/bin:$PATH:/usr/sbin:/sbin"

# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# Switch to Powerlevel10k theme for a more enhanced experience
ZSH_THEME="powerlevel10k/powerlevel10k"

# Completion Configurations
# Define the plugins array and add zsh-autocomplete to it

plugins=(
    zsh-autosuggestions
    zsh-syntax-highlighting
    zsh-interactive-cd
    zsh-z
    docker
    autojump
    colored-man-pages
)

# Source oh-my-zsh to load the framework.
source $ZSH/oh-my-zsh.sh

# Update Configurations
zstyle ':omz:update' mode reminder
zstyle ':omz:update' frequency 7

# User Configuration
export LANG=en_US.UTF-8
export EDITOR='vim'

# Enhanced directory navigation
autoload -Uz chpwd
chpwd() {
    ls
}

export ZSH_CUSTOM="$ZSH/custom"

# Personal Aliases
alias ls='exa'
alias la='exa -a'
alias ll='exa -la'
alias lt='exa -la --grid --sort=modified'
alias zshconfig="vim ~/.zshrc"
alias ohmyzsh="cd ~/.oh-my-zsh"

# Extraction function
# ...

# FZF for an interactive history search
# ...

# Placeholder for a random command tip. Modify as needed.
# ...

# End of the .zshrc file.

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh