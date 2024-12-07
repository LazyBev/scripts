#!/bin/bash

set -e

# Variables
print=false
help=false

# Parse arguments
for arg in "$@"; do
    case $arg in
        -p | --print-cpu)
            print=true
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
    # Detect CPU type
    if grep -q "Intel" /proc/cpuinfo; then
        cpu_type="Intel"
    else
        cpu_type="AMD"
    fi

    # Doing things absed on arguments chosen
    if [[ -z $print ]]; then
        if [[ $cpu_type == "Intel" ]]; then
            sudo pacman -Syu intel-ucode
        else
            sudo pacman -Syu amd-ucode
        fi
    else
        echo "You have an $cpu_type CPU"
    fi
else 
    echo "Options:"
    echo " -p, --print-cpu  only print CPU, no installing microcodes"
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

