#!/bin/bash

set -e

# Configuring /etc/pacman.conf
sudo sed -i "/Color/s/^#//g" /etc/pacman.conf || { echo "Failed to update pacman.conf"; exit 1; }
sudo sed -i "/ParallelDownloads/s/^#//g" /etc/pacman.conf || { echo "Failed to update pacman.conf"; exit 1; }
sudo sed -i "/#\\[multilib\\]/s/^#//" /etc/pacman.conf || { echo "Failed to update pacman.conf"; exit 1; }
sudo sed -i "/#Include = \\/etc\\/pacman\\.d\\/mirrorlist/s/^#//" /etc/pacman.conf || { echo "Failed to update pacman.conf"; exit 1; }
sudo sed -i '/#DisableSandbox/a ILoveCandy' /etc/pacman.conf || { echo "Failed to update pacman.conf"; exit 1; }

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
