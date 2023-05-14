# Symlink to ~/.zshrc

# Command history settings
HISTFILE=~/.cache/zsh_histfile
HISTSIZE=10000
SAVEHIST=10000

#############
# Variables #
#############

export EDITOR=nvim

# JellyFin docker compose directory
export JF_DC_DIR=/opt/jellyfin

###########
# Aliases #
###########

alias ls='lsd'
alias ll='ls -lh'
alias la='ls -a'
alias lla='ls -lha'

alias grep='grep --color=auto'

# Run JellyFin docker image via docker compose
alias jfrun='docker-compose --project-directory $JF_DC_DIR up'

alias wget='wget --hsts-file="$XDG_DATA_HOME/wget-hsts"'

#############
# Functions #
#############

#Import directory containing functions
export FPATH=$FPATH:~/.local/share/zfunctions

autoload searchpac
autoload unknow

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
