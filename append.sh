#!/bin/bash

apnd() {
    if [ $# -lt 2 ]; then
        echo "Usage: apnd <text> <file1> [file2 ... fileN]"
        echo "  <text>   - The text that you want to append to the files."
        echo "  <file1>  - The first file to append to."
        echo "  <file2>  - Additional files to append to (optional)."
        echo
        echo "Examples:"
        echo "  apnd \"Hello, World!\" file1.txt"
        echo "    - Appends \"Hello, World!\" to file1.txt and displays it in the terminal."
        echo
        echo "  apnd \"Some text\" file1.txt file2.txt"
        echo "    - Appends \"Some text\" to both file1.txt and file2.txt and displays it."
        echo
        echo "  apnd \"Important line\" /restricted/file1.txt"
        echo "    - Appends \"Important line\" to /restricted/file1.txt, using sudo if necessary."
        return 1
    fi

    local text="$1"
    shift

    # Loop over each file passed as argument
    for file in "$@"; do
        # Check if the file exists, if not, create it using touch
        if [ ! -e "$file" ]; then
            echo "File $file does not exist. Creating it."
            touch "$file"
        fi
    done

    # Create a temporary file to hold the input text
    tmpfile=$(mktemp)

    # Write the text to the temporary file
    echo "$text" > "$tmpfile"

    # Append the text to each file
    if [ "$EUID" -ne 0 ]; then
        sudo tee -a "$@" < "$tmpfile" > /dev/null
    else
        tee -a "$@" < "$tmpfile" > /dev/null
    fi

    # Clean up the temporary file
    rm -f "$tmpfile"
}
