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
    if ! $root && [[ $EUID -ne 0 ]]; then
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

    # Configuring /etc/pacman.conf
    run_command() sed -i "/Color/s/^#//g" /etc/pacman.conf || { echo "Failed to update pacman.conf"; exit 1; }
    run_command() sed -i "/ParallelDownloads/s/^#//g" /etc/pacman.conf || { echo "Failed to update pacman.conf"; exit 1; }
    run_command() sed -i "/#\\[multilib\\]/s/^#//" /etc/pacman.conf || { echo "Failed to update pacman.conf"; exit 1; }
    run_command() sed -i "/#Include = \\/etc\\/pacman\\.d\\/mirrorlist/s/^#//" /etc/pacman.conf || { echo "Failed to update pacman.conf"; exit 1; }
    run_command() sed -i '/#DisableSandbox/a ILoveCandy' /etc/pacman.conf || { echo "Failed to update pacman.conf"; exit 1; }
else
    echo "Options:"
    echo " -r, --root       run script with sudo"
    echo " -h, --help       display this help message"
fi

# Prompt the user to reboot
read -p "Would you like to reboot now? [y/N]: " reboot_choice
case $reboot_choice in
    y | Y)
        run_command reboot
        ;;
    *)
        echo "Reboot skipped. Please reboot manually if necessary."
        ;;
esac
