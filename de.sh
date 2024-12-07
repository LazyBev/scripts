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
        1) sudo pacman -Sy --noconfirm gnome gnome-shell gnome-session gdm ;;
        2) sudo pacman -Sy --noconfirm plasma kde-applications sddm ;;
        3) sudo pacman -Sy --noconfirm xfce4 xfce4-goodies lightdm lightdm-gtk-greeter ;;
        4) sudo pacman -Sy --noconfirm mate mate-extra lightdm ;;
        5) sudo pacman -Sy --noconfirm i3 ly dmenu kitty ;;
        *) echo "Invalid choice. Exiting."; exit 1 ;;
    esac 

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
