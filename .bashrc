# ~/.bashrc

# Check if the shell is running interactively; if not, exit this script
[[ $- != *i* ]] && return

# ----------- History Configuration -----------

# Control the behavior of bash history
export HISTCONTROL=ignoreboth  # Avoid logging duplicate commands and commands that start with a space
export HISTSIZE=5000           # Number of commands stored in memory
export HISTFILESIZE=10000      # Maximum size of the history file
shopt -s histappend            # Append to the history file instead of overwriting it
PROMPT_COMMAND="history -a;${PROMPT_COMMAND}"  # Save history after each command execution

# ----------- Prompt Configuration -----------

# Check if Starship (a modern shell prompt) is installed and initialize it
if command -v starship &> /dev/null; then
    eval "$(starship init bash)"
else
    # If Starship isn't installed, set up a basic colored prompt
    # Red for root user and green for normal users
    if [[ $EUID -eq 0 ]]; then
        PS1='\[\033[01;31m\]\u@\h:\[\033[01;34m\]\w\[\033[00m\]# '
    else
        PS1='\[\033[01;32m\]\u@\h:\[\033[01;34m\]\w\[\033[00m\]$ '
    fi
fi

# ----------- Aliases & Functions -----------

# Define aliases for 'ls' command using 'lsd' for better visual representation
alias ls='lsd'
alias ll='lsd -alF'
alias la='lsd -A'
alias l='lsd -CF'

# Shorten common Git commands
alias gs='git status'
alias ga='git add'
alias gc='git commit'
alias gp='git push'

# Shortcut for changing directories and then listing the contents
c() {
    cd "$@" || return
    ls
}

# Quickly reload .bashrc without restarting the terminal
alias refresh='source ~/.bashrc'

# Use colored output for 'tree' command
alias tree='tree -C'

# Use 'fasd' for efficient directory navigation if it's installed
if command -v fasd &> /dev/null; then
    alias z='fasd_cd -d'  # Jump to frequently accessed directories
fi

# ----------- Terminal Configuration -----------

# Set the default editor to 'nano'
export EDITOR='nano'

# Source any additional custom bash scripts from the ~/.bash/ directory
for file in ~/.bash/*.bash; do
    [[ -e "$file" ]] && source "$file"
done

# Load bash completion scripts if available
if [[ -f /usr/share/bash-completion/bash_completion ]]; then
    source /usr/share/bash-completion/bash_completion
elif [[ -f /etc/bash_completion ]]; then
    source /etc/bash_completion
fi

# Use 'safe-rm' as a safer alternative to the 'rm' command, if installed
alias rm='safe-rm'

PATH="$HOME/anaconda3/bin:$PATH"

# ----------- End of ~/.bashrc -----------
