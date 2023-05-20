# Symlink to ~/.config/zsh/.zprofile

# Start hyprland if on tty1
[ $(tty) = "/dev/tty1" ] && Hyprland &
