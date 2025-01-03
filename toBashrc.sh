#!/bin/bash

set -e

# Check if the apnd function already exists in ~/.bashrc
if ! grep -q "tbr()" ~/.bashrc; then
    # Append the apnd function to ~/.bashrc using tee
    sudo tee -a ~/.bashrc > /dev/null << 'EOF'
tbr() {
    # Variables
    help=false
    
    # Function to display usage
    usage() {
        echo "Usage: $0 <function_name> <script_file>"
        echo "Options:"
        echo "  <function_name> - The name of the function to define in .bashrc"
        echo "  <script_file>   - The path to the file containing the script for the function body"
        exit 1
    }
    
    # Parse arguments
    for arg in "$@"; do
        case $arg in
            -h | --help)
                help=true
                ;;
            *)
                echo "Invalid argument: $arg"
                help=true
                ;;
        esac
    done
    
    # If help is requested, show usage
    if $help; then
        usage
    fi
    
    # Ensure both function name and script file path are provided
    if [[ -z "$1" || -z "$2" ]]; then
        echo "Error: Both function name and script file path are required."
        usage
    fi
    
    # Function name and script file path
    FUNC_NAME="$1"
    SCRIPT_FILE="$2"
    
    # Check if the script file exists
    if [[ ! -f "$SCRIPT_FILE" ]]; then
        echo "Error: File not found: $SCRIPT_FILE"
        usage
    fi
    
    # Function to execute commands
    run_command() {
        if $root; then
            sudo "$@"
        else
            "$@"
        fi
    }
    # Remove the shebang line and set -<flag> lines, and indent the content by 4 spaces
    FILTERED_CONTENT=$(sed -e '/^#!/d' -e '/^set -/d' "$SCRIPT_FILE" | sed 's/^/    /')
    
    # Format the function definition
    FUNC_DEF="
    $FUNC_NAME() {
    $FILTERED_CONTENT
    }
    "
    
    # Append the function to .bashrc
    echo -e "\n# Function $FUNC_NAME added by script $FUNC_DEF" >> ~/.bashrc
    
    # Inform the user and auto source the .bashrc
    echo "Function '$FUNC_NAME' has been added to ~/.bashrc."
    echo "Sourcing ~/.bashrc now..."
    source ~/.bashrc
}
EOF
    echo "tbr function has been added to ~/.bashrc"
else
    echo "tbrfunction already exists in your ~/.bashrc"
fi

# Reload ~/.bashrc to apply changes
echo "Sourcing ~/.bashrc now..."
source ~/.bashrc
