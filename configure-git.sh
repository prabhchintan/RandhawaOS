#!/bin/bash
# Configure Git for RandhawaOS

echo "🔧 Configuring Git for RandhawaOS..."

# Set up Git identity
echo "📝 Setting up Git identity..."
git config --global user.name "Prabh Randhawa"
git config --global user.email "prabhchintan@users.noreply.github.com"

# Verify configuration
echo "✅ Git configuration:"
echo "Name: $(git config user.name)"
echo "Email: $(git config user.email)"

# Initialize and commit
cd /home/prab/RandhawaOS-GitHub

# Add all files
git add .

# Create initial commit
git commit -m "Initial RandhawaOS release v1.0.0

🌟 Features:
- Universal bootstrap script for any Linux distribution
- Barbell strategy: cutting-edge experience + rock-solid reproducibility  
- Container-based desktop environment (Hyprland + Wayland)
- Multi-layered package management (Pacman + Nix + Flatpak)
- System manifests with exact package versions
- Configuration templates for Hypr, Waybar, Kitty
- 25-year compatibility plan
- Automated backup system

🚀 One-line install: curl -fsSL https://raw.githubusercontent.com/prabhchintan/RandhawaOS/main/install.sh | bash

📦 Base System: Arch Linux with modern desktop environment
🎯 Philosophy: Nassim Taleb's barbell strategy for computing
🔮 Future-proof: Designed to work in 2050

Generated with RandhawaOS v1.0.0 - The Future-Proof Desktop"

echo "✅ Repository configured and committed!"
echo ""
echo "📋 Next steps:"
echo "1. Ensure GitHub repo exists: https://github.com/prabhchintan/RandhawaOS"
echo "2. Add remote: git remote add origin https://github.com/prabhchintan/RandhawaOS.git"
echo "3. Push: git push -u origin main"