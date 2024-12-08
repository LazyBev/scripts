#!/bin/bash

# Define locations
BATTERY_SCRIPT_PATH="$HOME/.config/i3blocks/battery.sh"
I3BLOCKS_CONF_PATH="$HOME/.config/i3blocks/config"

# Create the battery.sh script
echo "Creating battery.sh script..."

cat > "$BATTERY_SCRIPT_PATH" << 'EOF'
#!/bin/bash
# Get the full battery status (e.g., "Charging", "Discharging", "Not charging")
battery_status=$(acpi -b | awk -F', ' '{print $1}' | sed 's/ battery//')

# Get the battery percentage (e.g., "75%")
battery_percentage=$(acpi -b | grep -oP '(?<=, )\d+%' | head -n 1)

# Output both status and percentage
echo "$battery_status $battery_percentage"
EOF

# Make the script executable
chmod +x "$BATTERY_SCRIPT_PATH"

# Add the battery block to i3blocks.conf if it doesn't exist
echo "Adding battery block to i3blocks config..."

# Check if the battery block already exists
if ! grep -q "^\[battery\]" "$I3BLOCKS_CONF_PATH"; then
    echo -e "\n[battery]\ncommand=$BATTERY_SCRIPT_PATH\ninterval=30" >> "$I3BLOCKS_CONF_PATH"
    echo "Battery block added to i3blocks config."
else
    echo "Battery block already exists in i3blocks config."
fi

# Notify the user to reload i3
echo "Setup complete. Please reload i3 or i3blocks to apply changes."
