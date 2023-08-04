#!/usr/bin/env sh

## Author : Aditya Shakya (adi1090x)
## Github : @adi1090x
#
## Rofi   : Power Menu
#
## Available Styles
#
## style-1   style-2   style-3   style-4   style-5

# Current Theme
DIR=$(cd -- $(dirname $0) > /dev/null 2>&1 ; pwd)

# CMDs
uptime="`uptime -p | sed -e 's/up //g'`"
host=`cat /etc/hostname`

# Options
# shutdown=' Shutdown'
# reboot=' Reboot'
# lock=' Lock'
# suspend=' Suspend'
# logout=' Logout'
# yes=' Yes'
# no=' No'

shutdown='Shutdown'
reboot='Reboot'
lock='Lock'
suspend='Suspend'
logout='Logout'
yes='Yes'
no='No'

# Rofi CMD
rofi_cmd() {
	rofi -dmenu \
		-p "$host" \
		-mesg "Uptime: $uptime" \
		-theme ${DIR}/powermenu.rasi
}

# Confirmation CMD
confirm_cmd() {
	rofi -theme-str 'window {location: center; anchor: center; fullscreen: false; width: 250px;}' \
		-theme-str 'mainbox {children: [ "message", "listview" ];}' \
		-theme-str 'listview {columns: 2; lines: 1;}' \
		-theme-str 'element-text {horizontal-align: 0.5;}' \
		-theme-str 'textbox {horizontal-align: 0.5;}' \
		-dmenu \
		-p 'Confirmation' \
		-mesg 'Are you Sure?' \
		-theme ${DIR}/powermenu.rasi
}

# Ask for confirmation
confirm_exit() {
	printf "$yes\n$no" | confirm_cmd
}

# Pass variables to rofi dmenu
run_rofi() {
	printf "$lock\n$suspend\n$logout\n$reboot\n$shutdown" | rofi_cmd
}

run_cmd() {
	selected="$(confirm_exit)"
	if [ "$selected" = "$yes" ]
	then
		if [ "$1" = "--lock" ]
		then
			loginctl lock-session self
		elif [ "$1" = "--shutdown" ]
		then
			systemctl poweroff
		elif [ "$1" = "--reboot" ]
		then
			systemctl reboot
		elif [ "$1" = "--suspend" ]
		then
			systemctl suspend
		elif [ "$1" = "--logout" ]
		then
			if [ "$XDG_CURRENT_DESKTOP" = "Hyprland" ]
			then
				hyprctl dispatch exit
			fi
		fi
	else
		exit 0
	fi
}

# Actions
chosen="$(run_rofi)"
case ${chosen} in
    $shutdown)
		run_cmd --shutdown
        ;;
    $reboot)
		run_cmd --reboot
        ;;
    $lock)
		run_cmd --lock
        ;;
    $suspend)
		run_cmd --suspend
        ;;
    $logout)
		run_cmd --logout
        ;;
esac
