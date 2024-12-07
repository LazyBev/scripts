#!/bin/bash

set -e

# Variables
help=false

# Parse arguments
for arg in "$@"; do
    case $arg in
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
    sudo pacman -Syu alsa-utils pulseaudio pulseaudio-alsa pavucontrol
    sudo sed -i '/load-module module-suspend-on-idle/s/^/# /' /etc/pulse/default.pa
    sudo systemctl enable pulseaudio.service && systemctl start pulseaudio.service
    sudo bash -c 'echo "defaults.pcm.card 0" > /etc/asound.conf'
    sudo bash -c 'echo "defaults.ctl.card 0" >> /etc/asound.conf'

else
    echo "Options:"
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
