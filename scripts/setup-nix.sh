#!/bin/bash
# Setup Nix package manager for RandhawaOS

echo "🔧 Setting up Nix package manager..."

# Create /nix directory
sudo mkdir -m 0755 /nix && sudo chown $USER /nix

# Install Nix
curl -L https://nixos.org/nix/install | sh

# Source Nix profile
if [ -f ~/.nix-profile/etc/profile.d/nix.sh ]; then
    source ~/.nix-profile/etc/profile.d/nix.sh
fi

# Add Nix to shell profile
echo 'if [ -f ~/.nix-profile/etc/profile.d/nix.sh ]; then . ~/.nix-profile/etc/profile.d/nix.sh; fi' >> ~/.bashrc
echo 'if [ -f ~/.nix-profile/etc/profile.d/nix.sh ]; then . ~/.nix-profile/etc/profile.d/nix.sh; fi' >> ~/.zshrc

# Install Home Manager
nix-channel --add https://github.com/nix-community/home-manager/archive/master.tar.gz home-manager
nix-channel --update
nix-shell '<home-manager>' -A install

echo "✅ Nix installation completed!"
echo "🔄 Please restart your shell or run: source ~/.nix-profile/etc/profile.d/nix.sh"