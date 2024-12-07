#!/bin/bash

set -e

sudo pacman -Syu alsa-utils pulseaudio pulseaudio-alsa pavucontrol
sudo sed -i '/load-module module-suspend-on-idle/s/^/# /' /etc/pulse/default.pa
sudo systemctl enable pulseaudio.service && systemctl start pulseaudio.service
sudo bash -c 'echo "defaults.pcm.card 0" > /etc/asound.conf'
sudo bash -c 'echo "defaults.ctl.card 0" >> /etc/asound.conf'

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
