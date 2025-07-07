#!/bin/bash
# RandhawaOS Bootstrap Script
# Universal reproducible setup for any Linux system

set -e

RANDHAWA_VERSION="1.0.0"
RANDHAWA_DATE="2025-07-07"
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

logo() {
    echo -e "${PURPLE}"
    echo "██████╗  █████╗ ███╗   ██╗██████╗ ██╗  ██╗ █████╗ ██╗    ██╗ █████╗  ██████╗ ███████╗"
    echo "██╔══██╗██╔══██╗████╗  ██║██╔══██╗██║  ██║██╔══██╗██║    ██║██╔══██╗██╔═══██╗██╔════╝"
    echo "██████╔╝███████║██╔██╗ ██║██║  ██║███████║███████║██║ █╗ ██║███████║██║   ██║███████╗"
    echo "██╔══██╗██╔══██║██║╚██╗██║██║  ██║██╔══██║██╔══██║██║███╗██║██╔══██║██║   ██║╚════██║"
    echo "██║  ██║██║  ██║██║ ╚████║██████╔╝██║  ██║██║  ██║╚███╔███╔╝██║  ██║╚██████╔╝███████║"
    echo "╚═╝  ╚═╝╚═╝  ╚═╝╚═╝  ╚═══╝╚═════╝ ╚═╝  ╚═╝╚═╝  ╚═╝ ╚══╝╚══╝ ╚═╝  ╚═╝ ╚═════╝ ╚══════╝"
    echo -e "${NC}"
    echo -e "${CYAN}Universal • Reproducible • Future-Proof${NC}"
    echo -e "${YELLOW}Version $RANDHAWA_VERSION${NC}"
    echo ""
}

echo "🌟 RandhawaOS Bootstrap v${RANDHAWA_VERSION}"
echo "📅 Generated: ${RANDHAWA_DATE}"
echo "📂 Script directory: ${SCRIPT_DIR}"

# Detect distribution
detect_distro() {
    if [ -f /etc/os-release ]; then
        . /etc/os-release
        echo "🐧 Detected: $PRETTY_NAME"
        export DISTRO_ID="$ID"
        export DISTRO_NAME="$PRETTY_NAME"
    else
        echo "❌ Cannot detect distribution"
        exit 1
    fi
}

# Install package manager specific packages
install_packages() {
    local packages="$1"
    
    case "$DISTRO_ID" in
        arch)
            echo "📦 Installing packages with pacman..."
            sudo pacman -S --needed --noconfirm $packages
            ;;
        debian|ubuntu)
            echo "📦 Installing packages with apt..."
            sudo apt update
            sudo apt install -y $packages
            ;;
        fedora)
            echo "📦 Installing packages with dnf..."
            sudo dnf install -y $packages
            ;;
        opensuse*)
            echo "📦 Installing packages with zypper..."
            sudo zypper install -y $packages
            ;;
        *)
            echo "❌ Unsupported distribution: $DISTRO_ID"
            exit 1
            ;;
    esac
}

# Core system setup
setup_core() {
    echo "⚙️  Setting up core system..."
    
    # Create RandhawaOS directory
    mkdir -p "$HOME/.local/share/randhawa-os"
    mkdir -p "$HOME/.config/randhawa-os"
    
    # Copy repository files
    cp -r "$SCRIPT_DIR/manifests" "$HOME/.local/share/randhawa-os/"
    cp -r "$SCRIPT_DIR/scripts" "$HOME/.local/share/randhawa-os/"
    cp -r "$SCRIPT_DIR/containers" "$HOME/.local/share/randhawa-os/"
    cp "$SCRIPT_DIR/randhawa-os" "$HOME/.local/share/randhawa-os/"
    
    # Make scripts executable
    chmod +x "$HOME/.local/share/randhawa-os/randhawa-os"
    chmod +x "$HOME/.local/share/randhawa-os/scripts/"*.sh
    
    # Install essential packages (distribution-agnostic)
    case "$DISTRO_ID" in
        arch)
            install_packages "git curl wget base-devel"
            ;;
        debian|ubuntu)
            install_packages "git curl wget build-essential"
            ;;
        fedora)
            install_packages "git curl wget @development-tools"
            ;;
        opensuse*)
            install_packages "git curl wget -t pattern devel_basis"
            ;;
    esac
}

# Install AUR helper (Arch only)
setup_aur() {
    if [ "$DISTRO_ID" = "arch" ]; then
        echo "📦 Setting up AUR helper..."
        if ! command -v yay &> /dev/null; then
            cd /tmp
            git clone https://aur.archlinux.org/yay-bin.git
            cd yay-bin
            makepkg -si --noconfirm
            cd ..
            rm -rf yay-bin
        fi
    fi
}

# Setup containerization
setup_containers() {
    echo "🐳 Setting up containerization..."
    
    case "$DISTRO_ID" in
        arch)
            install_packages "docker podman flatpak"
            ;;
        debian|ubuntu)
            install_packages "docker.io podman flatpak"
            ;;
        fedora)
            install_packages "docker podman flatpak"
            ;;
        opensuse*)
            install_packages "docker podman flatpak"
            ;;
    esac
    
    # Add user to docker group
    if command -v docker &> /dev/null; then
        sudo usermod -aG docker $USER
    fi
    
    # Enable Flathub
    if command -v flatpak &> /dev/null; then
        flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
    fi
}

# Install Nix package manager
setup_nix() {
    echo "❄️  Setting up Nix package manager..."
    
    # Create /nix directory
    sudo mkdir -m 0755 /nix && sudo chown $USER /nix
    
    # Install Nix
    curl -L https://nixos.org/nix/install | sh
    
    # Source Nix profile
    if [ -f ~/.nix-profile/etc/profile.d/nix.sh ]; then
        . ~/.nix-profile/etc/profile.d/nix.sh
    fi
    
    # Add to shell profiles
    echo 'if [ -f ~/.nix-profile/etc/profile.d/nix.sh ]; then . ~/.nix-profile/etc/profile.d/nix.sh; fi' >> ~/.bashrc
    echo 'if [ -f ~/.nix-profile/etc/profile.d/nix.sh ]; then . ~/.nix-profile/etc/profile.d/nix.sh; fi' >> ~/.zshrc
}

# Setup dotfiles management
setup_dotfiles() {
    echo "📁 Setting up dotfiles management..."
    
    # Create dotfiles repository structure
    mkdir -p "$HOME/.local/share/randhawa-os/dotfiles"
    
    # Copy configuration templates
    if [ -d "$SCRIPT_DIR/configs" ]; then
        cp -r "$SCRIPT_DIR/configs/"* "$HOME/.local/share/randhawa-os/dotfiles/"
    fi
    
    # Copy current configs if they exist
    for config in hypr waybar kitty rofi dunst; do
        if [ -d "$HOME/.config/$config" ]; then
            cp -r "$HOME/.config/$config" "$HOME/.local/share/randhawa-os/dotfiles/"
        fi
    done
}

# Create system-wide command
setup_command() {
    echo "🔧 Setting up system-wide command..."
    
    # Create symlink for system-wide access
    sudo ln -sf "$HOME/.local/share/randhawa-os/randhawa-os" /usr/local/bin/randhawa-os
    
    # Add to PATH if not already there
    if ! echo $PATH | grep -q "$HOME/.local/share/randhawa-os"; then
        echo 'export PATH="$HOME/.local/share/randhawa-os:$PATH"' >> ~/.bashrc
        echo 'export PATH="$HOME/.local/share/randhawa-os:$PATH"' >> ~/.zshrc
    fi
}

# Main execution
main() {
    logo
    echo "🚀 Starting RandhawaOS bootstrap..."
    
    detect_distro
    setup_core
    setup_aur
    setup_containers
    setup_nix
    setup_dotfiles
    setup_command
    
    echo ""
    echo -e "${GREEN}✅ RandhawaOS bootstrap completed!${NC}"
    echo -e "${YELLOW}🔄 Please reboot or re-login to apply all changes${NC}"
    echo ""
    echo "📖 Next steps:"
    echo "   1. Restart your shell: source ~/.bashrc"
    echo "   2. Check status: randhawa-os status"
    echo "   3. Build containers: randhawa-os container build"
    echo "   4. Create snapshot: randhawa-os snapshot create"
    echo ""
    echo -e "${CYAN}🎉 Welcome to RandhawaOS - The Future-Proof Desktop!${NC}"
}

# Run main function
main "$@"