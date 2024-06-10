# Symlink to ~/.config/zsh/.zshrc

# Command history settings
HISTFILE=~/.cache/zsh_histfile
HISTSIZE=100000
SAVEHIST=100000

export PATH=$PATH:~/.local/share/scripts/
export PATH=$PATH:~/.local/bin/

#############
# Variables #
#############

export EDITOR=nvim

###########
# Aliases #
###########

alias l='lsd'
alias ll='lsd -lh'
alias la='lsd -a'
alias lla='lsd -lha'
alias lt='lsd --tree'

alias wget='wget --hsts-file="$XDG_DATA_HOME/wget-hsts"'

alias p='pacman'
alias s='sudo '
alias n='nvim'
alias c='cd'
alias m='mkdir --parents'

alias h='history 1 | grep'

alias bash="HOME=$HOME/.local/share/fakehome bash"

alias grep="rg"

#############
# Functions #
#############

#Import directory containing functions
export FPATH=$FPATH:~/.local/share/zfunctions

autoload unknow
autoload t
autoload g
autoload pm
autoload cn

###########
# Plugins #
###########

# Load syntax highlighting
source /usr/share/zsh/plugins/fast-syntax-highlighting/fast-syntax-highlighting.plugin.zsh

# Load Starship prompt
eval "$(starship init zsh)"

# Load zoxide as replacement for 'cd'
eval "$(zoxide init --cmd='cd' zsh)"

# Load VI mode
source /usr/share/zsh/plugins/zsh-vi-mode/zsh-vi-mode.plugin.zsh

# Set pfetch variables and display
export PF_INFO="ascii title os kernel de shell editor uptime pkgs memory palette"
pfetch

autoload -U compinit; compinit

compdef g=git
compdef t=tmux

# compinit -d "$XDG_CACHE_HOME"/zsh/zcompdump-"$ZSH_VERSION"
