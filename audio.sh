#!/bin/bash

set -e

# Variables
root=false
help=false

# Parse arguments
for arg in "$@"; do
    case $arg in
		-r | --root)
  			root=true
            ;;
	    -h | --help)
            help=true
            ;;
	    *)
  	    	echo "Invalid argument. Give correct arguments"
	    	help=true
	    	;;
    esac
done


if ! $help; then

    # Check for root privileges
    if ! $root || [[ $EUID -ne 0 ]]; then
        echo "Please run as root or use the -r option or run this script with sudo"
        exit 1
    fi

	# Function to execute commands
    run_command() {
        if $root; then
            sudo "$@"
        else
            "$@"
        fi
    }

 	run_command pacman -Syu alsa-utils pulseaudio pulseaudio-alsa pulseaudio-bluetooth pavucontrol
  	run_command sed -i '/load-module module-suspend-on-idle/s/^/# /' /etc/pulse/default.pa
	run_command systemctl enable pulseaudio.service && systemctl start pulseaudio.service
 	sudo bash -c 'echo "defaults.pcm.card 0" > /etc/asound.conf'
    sudo bash -c 'echo "defaults.ctl.card 0" >> /etc/asound.conf'

else
    echo "Options:"
    echo " -r, --root       run script with sudo"
    echo " -h, --help       display this help message"
fi

# Prompt the user to reboot
read -p "Would you like to reboot now? [y/N]: " reboot_choice
case $reboot_choice in
    y | Y)
        reboot
        ;;
    *)
        echo "Reboot skipped. Please reboot manually if necessary."
        ;;
esac
