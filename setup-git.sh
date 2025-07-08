#!/bin/bash
# Git Repository Setup for RandhawaOS

set -e

REPO_DIR="/home/prab/RandhawaOS-GitHub"
BACKUP_SCRIPT="/home/prab/.local/share/randhawa-os/backup-to-git.sh"

echo "🔧 Setting up Git repository for RandhawaOS..."

# Initialize Git repository
cd "$REPO_DIR"
git init

# Add all files
git add .

# Create initial commit
git commit -m "Initial RandhawaOS release

- Universal bootstrap script for any Linux distribution
- Barbell strategy: cutting-edge experience + rock-solid reproducibility
- Container-based desktop environment
- Multi-layered package management (Pacman + Nix + Flatpak)
- System manifests and configuration templates
- 25-year compatibility plan

🚀 Generated with RandhawaOS v1.0.0"

echo "✅ Git repository initialized"
echo ""
echo "📋 Next steps:"
echo "1. Create GitHub repository: https://github.com/new"
echo "2. Add remote: git remote add origin https://github.com/your-username/RandhawaOS.git"
echo "3. Push: git push -u origin main"
echo ""

# Create automated backup script
echo "🔄 Creating automated backup script..."
cat > "$BACKUP_SCRIPT" << 'EOF'
#!/bin/bash
# Automated RandhawaOS Backup to Git

set -e

RANDHAWA_DIR="$HOME/.local/share/randhawa-os"
REPO_DIR="$HOME/RandhawaOS-GitHub"
DATE=$(date +"%Y-%m-%d_%H-%M-%S")

echo "🔄 Starting automated RandhawaOS backup..."

# Update manifests
echo "📋 Updating manifests..."
cd "$RANDHAWA_DIR"

# Generate current package list
if command -v pacman &> /dev/null; then
    pacman -Qe > "$REPO_DIR/manifests/current-packages.txt"
fi

# Update system manifest with current info
cat > "$REPO_DIR/manifests/system-manifest-current.json" << EOM
{
  "randhawa_os": {
    "version": "1.0.0",
    "last_backup": "$(date -Iseconds)",
    "base_system": "$(grep '^ID=' /etc/os-release | cut -d'=' -f2 | tr -d '"')",
    "kernel": "$(uname -r)",
    "hostname": "$(hostname)",
    "timezone": "$(timedatectl show --property=Timezone --value)"
  }
}
EOM

# Copy current configs
echo "📁 Backing up configurations..."
for config in hypr waybar kitty rofi dunst; do
    if [ -d "$HOME/.config/$config" ]; then
        cp -r "$HOME/.config/$config" "$REPO_DIR/configs/" 2>/dev/null || true
    fi
done

# Backup snapshots with security filtering
echo "📸 Backing up snapshots..."
if [ -d "$RANDHAWA_DIR/snapshots" ]; then
    mkdir -p "$REPO_DIR/snapshots"
    
    for snapshot_dir in "$RANDHAWA_DIR/snapshots"/*; do
        if [ -d "$snapshot_dir" ]; then
            snapshot_name=$(basename "$snapshot_dir")
            target_dir="$REPO_DIR/snapshots/$snapshot_name"
            
            # Create filtered snapshot backup
            mkdir -p "$target_dir"
            
            # Copy safe files only
            if [ -f "$snapshot_dir/packages.txt" ]; then
                cp "$snapshot_dir/packages.txt" "$target_dir/" 2>/dev/null || true
            fi
            
            if [ -f "$snapshot_dir/system_info.txt" ]; then
                cp "$snapshot_dir/system_info.txt" "$target_dir/" 2>/dev/null || true
            fi
            
            # Copy .config but filter out sensitive files
            if [ -d "$snapshot_dir/.config" ]; then
                mkdir -p "$target_dir/.config"
                
                # Copy config directories, excluding sensitive ones
                for config_item in "$snapshot_dir/.config"/*; do
                    if [ -d "$config_item" ]; then
                        config_name=$(basename "$config_item")
                        
                        # Skip sensitive config directories
                        case "$config_name" in
                            "ssh"|"gnupg"|"gpg"|"keyring"|"evolution"|"telepathy"|"goa-1.0"|"chrome"|"chromium"|"mozilla"|"firefox")
                                continue
                                ;;
                        esac
                        
                        mkdir -p "$target_dir/.config/$config_name"
                        
                        # Copy files but exclude sensitive patterns
                        find "$config_item" -type f | while read -r file; do
                            filename=$(basename "$file")
                            relative_path="${file#$config_item/}"
                            
                            # Skip files with sensitive patterns
                            case "$filename" in
                                *password*|*secret*|*key*|*token*|*credential*|*wallet*|*keystore*|*priv*|cookies*|history*|cache*)
                                    continue
                                    ;;
                                *.pem|*.key|*.p12|*.pfx|*.crt|*.csr)
                                    continue
                                    ;;
                            esac
                            
                            # Skip files containing sensitive content patterns
                            if file -b "$file" | grep -q text && grep -qiE "(password|secret|private.*key|token|credential)" "$file" 2>/dev/null; then
                                continue
                            fi
                            
                            # Copy the safe file
                            target_file="$target_dir/.config/$config_name/$relative_path"
                            mkdir -p "$(dirname "$target_file")"
                            cp "$file" "$target_file" 2>/dev/null || true
                        done
                    fi
                done
            fi
        fi
    done
fi

# Commit changes
cd "$REPO_DIR"
if [ -n "$(git status --porcelain)" ]; then
    git add .
    git commit -m "Automated backup: $DATE

- Updated package lists
- Synced configuration files
- System state snapshot
- Backed up system snapshots (filtered for security)

🤖 Automated backup from $(hostname)"
    
    echo "✅ Changes committed"
    
    # Push if remote exists
    if git remote | grep -q origin; then
        git push origin main && echo "🚀 Pushed to GitHub" || echo "⚠️ Push failed - check network"
    else
        echo "⚠️ No remote configured - run: git remote add origin <your-repo-url>"
    fi
else
    echo "ℹ️ No changes to backup"
fi

echo "✅ Backup completed"
EOF

chmod +x "$BACKUP_SCRIPT"

echo "✅ Automated backup script created: $BACKUP_SCRIPT"
echo ""
echo "🕒 To set up automatic backups, add to crontab:"
echo "   # Daily backup at 2 AM"
echo "   0 2 * * * $BACKUP_SCRIPT"
echo ""
echo "Or run manually: $BACKUP_SCRIPT"