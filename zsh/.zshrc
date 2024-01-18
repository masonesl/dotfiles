# Symlink to ~/.config/zsh/.zshrc

# Command history settings
HISTFILE=~/.cache/zsh_histfile
HISTSIZE=10000
SAVEHIST=10000

export PATH=$PATH:~/.local/share/scripts/

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

alias grep='grep --color=auto'

alias wget='wget --hsts-file="$XDG_DATA_HOME/wget-hsts"'

alias p='pacman'
alias s='sudo '
alias n='nvim'
alias c='cd'

alias g='git'
alias ga='git add'
alias gc='git commit -m'
alias gp='git push'

alias h='history 1 | grep'

alias bash="HOME=$HOME/.local/share/fakehome bash"

#############
# Functions #
#############

#Import directory containing functions
export FPATH=$FPATH:~/.local/share/zfunctions

autoload searchpac
autoload unknow
autoload nv

###########
# Plugins #
###########

# Load syntax highlighting
source /usr/share/zsh/plugins/fast-syntax-highlighting/fast-syntax-highlighting.plugin.zsh

# Load Starship prompt
eval "$(starship init zsh)"

# Load VI mode
source /usr/share/zsh/plugins/zsh-vi-mode/zsh-vi-mode.plugin.zsh

# Set pfetch variables and display
export PF_INFO="ascii title os kernel de shell editor uptime pkgs memory palette"
pfetch

autoload -U compinit; compinit

compinit -d "$XDG_CACHE_HOME"/zsh/zcompdump-"$ZSH_VERSION"

# EOF
