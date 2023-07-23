# Enhance the PATH variable.
export PATH="$HOME/bin:/usr/local/bin:$PATH:/usr/sbin:/sbin"

# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# Switch to Powerlevel10k theme for a more enhanced experience
ZSH_THEME="powerlevel10k/powerlevel10k"

# Completion Configurations
plugins=( ${plugins[@]} zsh-autocomplete )
plugins=( ${plugins[@]/zsh-completions} )

# Update Configurations
zstyle ':omz:update' mode reminder
zstyle ':omz:update' frequency 7

# Additional Plugins
plugins+=(
    colored-man-pages
    docker
    autojump
)

# Source oh-my-zsh to load the framework.
source $ZSH/oh-my-zsh.sh

# User Configuration
export LANG=en_US.UTF-8
export EDITOR='vim'

# Enhanced directory navigation
autoload -Uz chpwd
chpwd() {
    ls
}

# Personal Aliases
alias ls='exa'
alias la='exa -a'
alias ll='exa -la'
alias lt='exa -la --grid --sort=modified'
alias zshconfig="vim ~/.zshrc"
alias ohmyzsh="cd ~/.oh-my-zsh"

# Extraction function
extract() {
    if [ -f "$1" ]; then
        case "$1" in
            *.tar.bz2)  tar xjf "$1"     ;;
            *.tar.gz)   tar xzf "$1"     ;;
            *.bz2)      bunzip2 "$1"     ;;
            *.rar)      unrar x "$1"     ;;
            *.gz)       gunzip "$1"      ;;
            *.tar)      tar xf "$1"      ;;
            *.tbz2)     tar xjf "$1"     ;;
            *.tgz)      tar xzf "$1"     ;;
            *.zip)      unzip "$1"       ;;
            *.Z)        uncompress "$1"  ;;
            *.7z)       7z x "$1"        ;;
            *)          echo "don't know how to extract '$1'" ;;
        esac
    else
        echo "'$1' is not a valid file!"
    fi
}

# FZF for an interactive history search
bindkey '^R' history-incremental-search-backward
autoload -Uz up-line-or-beginning-search
autoload -Uz down-line-or-beginning-search
zle -N up-line-or-beginning-search
zle -N down-line-or-beginning-search
bindkey "^[[A" up-line-or-beginning-search
bindkey "^[[B" down-line-or-beginning-search

# Placeholder for a random command tip. Modify as needed.
print -P "%F{33}You can use %F{220}%Bsome-command%b%f for [description of the command]"

# End of the .zshrc file.
