#!/bin/bash
# RandhawaOS Complete System Restore Script
# Run this on any Linux machine to restore your complete RandhawaOS setup

set -e

REPO_URL="https://github.com/prabhchintan/RandhawaOS.git"
TEMP_DIR=$(mktemp -d)
RESTORE_LOG="$HOME/randhawa-restore-$(date +%Y%m%d_%H%M%S).log"

echo "🔄 RandhawaOS Complete System Restore"
echo "📋 Restore log: $RESTORE_LOG"
echo ""

log() {
    echo "$(date '+%Y-%m-%d %H:%M:%S') $1" | tee -a "$RESTORE_LOG"
}

log "🚀 Starting RandhawaOS restore from GitHub..."

# Clone repository
log "📦 Cloning RandhawaOS repository..."
cd "$TEMP_DIR"
git clone "$REPO_URL" randhawa-os
cd randhawa-os

# Run bootstrap
log "🔧 Running RandhawaOS bootstrap..."
chmod +x bootstrap.sh
./bootstrap.sh

# Restore configurations
log "📁 Restoring configurations..."
if [ -d configs ]; then
    # Backup existing configs
    BACKUP_DIR="$HOME/.config-backup-$(date +%Y%m%d_%H%M%S)"
    mkdir -p "$BACKUP_DIR"
    
    for config_dir in configs/*/; do
        if [ -d "$config_dir" ]; then
            config_name=$(basename "$config_dir")
            if [ "$config_name" != "dotfiles" ] && [ "$config_name" != "ssh" ]; then
                if [ -d "$HOME/.config/$config_name" ]; then
                    log "  💾 Backing up existing ~/.config/$config_name"
                    mv "$HOME/.config/$config_name" "$BACKUP_DIR/"
                fi
                
                log "  📂 Restoring ~/.config/$config_name"
                mkdir -p "$HOME/.config"
                cp -r "$config_dir" "$HOME/.config/$config_name"
            fi
        fi
    done
    
    # Restore dotfiles
    if [ -d configs/dotfiles ]; then
        log "📋 Restoring dotfiles..."
        for dotfile in configs/dotfiles/.*; do
            if [ -f "$dotfile" ]; then
                filename=$(basename "$dotfile")
                if [ -f "$HOME/$filename" ]; then
                    cp "$HOME/$filename" "$BACKUP_DIR/"
                fi
                log "  📄 Restoring ~/$filename"
                cp "$dotfile" "$HOME/"
            fi
        done
    fi
    
    # Restore SSH config
    if [ -d configs/ssh ]; then
        log "🔐 Restoring SSH configuration..."
        mkdir -p "$HOME/.ssh"
        chmod 700 "$HOME/.ssh"
        
        if [ -f configs/ssh/config ]; then
            cp configs/ssh/config "$HOME/.ssh/"
            chmod 600 "$HOME/.ssh/config"
        fi
        
        cp configs/ssh/*.pub "$HOME/.ssh/" 2>/dev/null || true
        chmod 644 "$HOME/.ssh/"*.pub 2>/dev/null || true
    fi
fi

# Install packages from manifests
if [ -f manifests/packages-explicit-current.txt ] && command -v pacman &> /dev/null; then
    log "📦 Installing Arch packages..."
    # Extract package names (remove version numbers)
    grep -v '^#' manifests/packages-explicit-current.txt | \
        awk '{print $1}' > /tmp/packages-to-install.txt
    
    # Install packages
    sudo pacman -S --needed - < /tmp/packages-to-install.txt || log "⚠️ Some packages failed to install"
fi

if [ -f manifests/packages-flatpak-current.txt ] && command -v flatpak &> /dev/null; then
    log "📱 Installing Flatpak packages..."
    while read -r app; do
        [ -z "$app" ] || flatpak install -y flathub "$app" 2>/dev/null || log "⚠️ Failed to install $app"
    done < manifests/packages-flatpak-current.txt
fi

# Set up automated backups
log "🔄 Setting up automated backups..."
if [ -f scripts/setup-automation.sh ]; then
    chmod +x scripts/setup-automation.sh
    ./scripts/setup-automation.sh
fi

log "✅ RandhawaOS restore completed!"
log "📁 Configuration backups saved to: $BACKUP_DIR"
log "🔄 Please reboot to ensure all changes take effect"

echo ""
echo "🎉 Welcome back to RandhawaOS!"
echo "📋 Restore log saved to: $RESTORE_LOG"
echo "🔄 Run 'randhawa-os status' to verify your system"

# Cleanup
cd "$HOME"
rm -rf "$TEMP_DIR"
