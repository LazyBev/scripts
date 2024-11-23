#!/bin/bash

sed -i "/Color/s/^#//g" /etc/pacman.conf || { echo "Failed to update pacman.conf"; exit 1; }
sed -i "/ParallelDownloads/s/^#//g" /etc/pacman.conf || { echo "Failed to update pacman.conf"; exit 1; }
sed -i "/#\\[multilib\\]/s/^#//" /etc/pacman.conf || { echo "Failed to update pacman.conf"; exit 1; }
sed -i "/#Include = \\/etc\\/pacman\\.d\\/mirrorlist/s/^#//" /etc/pacman.conf || { echo "Failed to update pacman.conf"; exit 1; }
sed -i '/#DisableSandbox/a ILoveCandy' /etc/pacman.conf || { echo "Failed to update pacman.conf"; exit 1; }
