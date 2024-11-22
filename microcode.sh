#!/bin/bash

# Variables
root=false
print=false
help=false

# Parse command-line arguments
for arg in "$@"; do
    case $arg in
        -r | --root)
            root=true
            ;;
        -p | --print)
            print=true
            ;;
        -h | --help)
            help=true
            ;;
    esac
done

if ! $help; then
    # Check for root privileges if not using sudo
    if ! $root && [[ $EUID -ne 0 ]]; then
        echo "Please run as root or use the -r option or run this script with sudo"
        exit 1
    fi

    # Detect CPU type using /proc/cpuinfo
    if grep -q "Intel" /proc/cpuinfo; then
        cpu_type="Intel"
    else
        cpu_type="AMD"
    fi
    
    # Function to execute commands with or without sudo
    run_command() {
        if $root; then
            sudo "$@"
        else
            "$@"
        fi
    }

    # Perform actions based on arguments and detected CPU
    if [[ -z $print ]]; then
        if [[ $cpu_type == "Intel" ]]; then
            run_command pacman -Syu intel-ucode
        else
            run_command pacman -Syu amd-ucode
        fi
    else
        echo "You have an $cpu_type CPU"
    fi
else 
    echo "Options:"
    echo " -r, --root   run script with sudo"
    echo " -p, --print  only print CPU, no installing microcodes"
    echo " -h, --help   display this help message"
