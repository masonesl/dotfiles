# Symlink to ~/.zshrc

# Command history settings
HISTFILE=~/.cache/zfs_histfile
HISTSIZE=10000
SAVEHIST=10000

#############
# Variables #
#############

export EDITOR=nvim

# TODO: Move these variables to another local file

# Directory where hugo site is located
export HUGO_SITE_DIR=~/Documents/MasonEsslinger
# Address and path to website root on webserver
export SITE_ROOT='masonxyz:/var/www/masonxyz'


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

# Start hugo server
alias hgserver='hugo server -s $HUGO_SITE_DIR --noHTTPCache -D > /tmp/hugo.log 2>&1 &'

# Push local website files to web server
alias webpush='rsync -ru $HUGO_SITE_DIR/public/* masonxyz:/var/www/masonxyz'

# Run JellyFin docker image via docker compose
alias jfrun='docker-compose --project-directory $JF_DC_DIR up'

#############
# Functions #
############# 

# Sync the /boot directory with the EFI partition to be able to bypass ZFSBootMenu
syncboot() {
	sudo rsync --exclude="*/" /boot/* /efi/ARCH
}

# Function for searching packages installed via pacman or aur
searchpac() {
	paru -Q | grep "$1"
}

# TODO: Move functions to their own folder

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

# EOF