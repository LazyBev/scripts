#!/bin/bash

set -e

# Variables
display=""
brightness=""
help=false

# Parse arguments
while [[ "$#" -gt 0 ]]; do
    case $1 in
        -d|--display)
            display="$2"
            shift 2
            ;;
        -b|--bright|--brightness)
            brightness="$2"
            shift 2
            ;;
        -h|--help)
            help=true
            shift
            ;;
        *)
            echo "Invalid argument: $1"
            help=true
            shift
            ;;
    esac
done

# Display help message if requested or no arguments are provided
if [[ "$help" == "true" || -z "$display" && -z "$brightness" ]]; then
    echo "Options:"
    echo " -d | --display               Choose which display to change brightness"
    echo " -b | --bright | --brightness Changes the brightness (0 - 1)"
    echo " -h | --help                  Display this help message"
    return
fi

# Function to change brightness
if [[ -n "$display" && -n "$brightness" ]]; then
    if ! [[ "$brightness" =~ ^[0-9]+(\.[0-9]+)?$ ]]; then
        echo "Error: Brightness must be a number between 0 and 1."
        return
    fi
    if xrandr | grep -q "$display connected"; then
        xrandr --output "$display" --brightness "$brightness"
        echo "Brightness set to $brightness for display $display."
    else
        echo "Error: Display '$display' not found or not connected."
    fi
elif [[ -z "$display" ]]; then
    echo "Error: Display must be specified."
elif [[ -z "$brightness" ]]; then
    echo "Error: Brightness must be specified."
fi
