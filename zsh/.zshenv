# Symlink to ~/.config/zsh
# Make sure to put 'export ZDOTDIR="$XDG_CONFIG_HOME/zsh"' in /etc/zsh/zshenv

# XDG Variables
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_STATE_HOME="$HOME/.local/state"
export XDG_CACHE_HOME="$HOME/.cache"

# Variables to keep a clean ~
export CARGO_HOME="$XDG_DATA_HOME/cargo"
export GNUPGHOME="$XDG_DATA_HOME/gnupg"
export GOPATH="$XDG_DATA_HOME/go"
export GTK2_RC_FILES="$XDG_CONFIG_HOME/gtk-2.0/gtkrc"
export KDEHOME="$XDG_CONFIG_HOME/kde"
export LESSHISTFILE="$XDG_CACHE_HOME/less/history"
export NUGET_PACKAGES="$XDG_CACHE_HOME/NuGetPackages"
export PASSWORD_STORE_DIR="$XDG_DATA_HOME/pass"
export PYTHONSTARTUP="${XDG_CONFIG_HOME}/python/pythonrc"
export XAUTHORITY="$XDG_RUNTIME_DIR/Xauthority"
export RUSTUP_HOME="$XDG_DATA_HOME/rustup"

export EWW_CONFIG="$XDG_CONFIG_HOME/eww"
