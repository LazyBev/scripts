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

    # Prompt for desktop environment selection
    echo "Select a desktop environment to install:"
    echo "1) GNOME"
    echo "2) KDE Plasma"
    echo "3) XFCE"
    echo "4) MATE"
    echo "5) i3 with ly (Window Manager)"
    read -p "Enter your choice (1-5): " de_choice 
    echo ""

    case $de_choice in
        1) run_command pacman -Sy --noconfirm gnome gnome-shell gnome-session gdm ;;
        2) run_command pacman -Sy --noconfirm plasma kde-applications sddm ;;
        3) run_command pacman -Sy --noconfirm xfce4 xfce4-goodies lightdm lightdm-gtk-greeter ;;
        4) run_command pacman -Sy --noconfirm mate mate-extra lightdm ;;
        5) run_command pacman -Sy --noconfirm i3 ly dmenu kitty ;;
        *) echo "Invalid choice. Exiting."; exit 1 ;;
    esac 

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
