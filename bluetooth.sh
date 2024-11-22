#!/bin/bash

set -e

sudo pacman -S bluez bluez-utils blueman
sudo systemctl enable bluetooth.service
sudo systemctl start bluetooth.service
sudo systemctl daemon-reload
echo "alias blueman='blueman-manager'" >> ~/.bashrc
source ~/.bashrc

read -p "Would you like to reboot now? [y/N]: " reboot_choice
case $reboot_choice in
    y)
        run_command reboot
        ;;
    *)
        echo "Reboot skipped. Please reboot manually if necessary."
        ;;
esac
