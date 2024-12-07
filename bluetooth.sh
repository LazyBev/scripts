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
    sudo pacman -S bluez bluez-utils blueman pulseaudio-bluetooth
    sudo systemctl enable bluetooth.service
    sudo systemctl start bluetooth.service
    sudo systemctl daemon-reload

    # Check if the alias already exists in .bashrc
    if ! grep -q "alias blueman=" ~/.bashrc; then
        echo "Adding Blueman alias to .bashrc..."
	echo "alias blueman='blueman-manager'" >> ~/.bashrc
        source ~/.bashrc
    else
        echo "Blueman alias already exists in .bashrc. Skipping addition."
    fi
else
    echo "Options:"
    echo " -h, --help       display this help message"
fi

read -p "Would you like to reboot now? [y/N]: " reboot_choice
case $reboot_choice in
    y | Y)
        reboot
        ;;
    *)
        echo "Reboot skipped. Please reboot manually if necessary."
        ;;
esac
