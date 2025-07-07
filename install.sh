#!/bin/bash
# RandhawaOS Quick Installer
# Downloads and runs the full bootstrap script

set -e

REPO_URL="https://github.com/your-username/RandhawaOS"
TEMP_DIR=$(mktemp -d)

echo "🌟 RandhawaOS Quick Installer"
echo "📦 Downloading from: $REPO_URL"

# Clone repository
cd "$TEMP_DIR"
git clone "$REPO_URL.git" randhawa-os
cd randhawa-os

# Make bootstrap executable and run
chmod +x bootstrap.sh
./bootstrap.sh

# Cleanup
cd "$HOME"
rm -rf "$TEMP_DIR"

echo "✅ RandhawaOS installation completed!"
echo "🔄 Please reboot or logout/login to apply all changes"