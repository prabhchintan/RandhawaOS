#!/bin/bash
# BTRFS Migration Script for RandhawaOS
# DANGER: This script will modify your filesystem - backup first!

set -e

BACKUP_DIR="/home/prab/randhawa-backup"
RANDHAWA_DIR="/home/prab/.local/share/randhawa-os"

echo "🚨 BTRFS Migration for RandhawaOS"
echo "⚠️  WARNING: This will modify your filesystem!"
echo "📋 Current filesystem: LVM on ext4"
echo "🎯 Target filesystem: BTRFS with snapshots"
echo ""

# Safety check
read -p "Have you backed up your system? (y/N): " -n 1 -r
echo
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    echo "❌ Please backup your system first!"
    exit 1
fi

echo "📊 Current filesystem layout:"
lsblk -f
echo ""

echo "💾 Available space for migration:"
df -h
echo ""

# Create backup directory
mkdir -p "$BACKUP_DIR"

echo "📦 Creating system backup..."
rsync -aHAXxv --numeric-ids --progress \
    --exclude='/dev/*' \
    --exclude='/proc/*' \
    --exclude='/sys/*' \
    --exclude='/tmp/*' \
    --exclude='/run/*' \
    --exclude='/mnt/*' \
    --exclude='/media/*' \
    --exclude='/lost+found' \
    --exclude='/home/prab/randhawa-backup' \
    / "$BACKUP_DIR/"

echo "✅ Backup completed to $BACKUP_DIR"

# Migration strategy options
echo ""
echo "🔄 Migration options:"
echo "1. In-place conversion (ext4 to BTRFS) - RISKY"
echo "2. Fresh BTRFS installation - RECOMMENDED"
echo "3. Dual-boot setup - SAFEST"
echo ""

read -p "Choose migration strategy (1-3): " -n 1 -r
echo

case $REPLY in
    1)
        echo "⚠️  In-place conversion selected"
        echo "🔧 This will convert your existing ext4 to BTRFS"
        echo "📋 Steps:"
        echo "   1. Unmount filesystems"
        echo "   2. Convert ext4 to BTRFS"
        echo "   3. Update /etc/fstab"
        echo "   4. Regenerate initramfs"
        echo "   5. Update bootloader"
        echo ""
        echo "❌ NOT IMPLEMENTED - Too risky for automated script"
        echo "🔗 Manual guide: https://wiki.archlinux.org/title/Btrfs#Conversion_from_ext4"
        ;;
    2)
        echo "🆕 Fresh BTRFS installation selected"
        echo "📋 Steps:"
        echo "   1. Create new BTRFS partition"
        echo "   2. Setup subvolumes (@, @home, @var, @tmp)"
        echo "   3. Restore data from backup"
        echo "   4. Configure snapshots"
        echo "   5. Update bootloader"
        echo ""
        echo "❌ NOT IMPLEMENTED - Requires manual partitioning"
        echo "🔗 Manual guide: https://wiki.archlinux.org/title/Btrfs#Installation"
        ;;
    3)
        echo "🔄 Dual-boot setup selected"
        echo "📋 This will preserve your current system"
        echo "   1. Shrink existing partitions"
        echo "   2. Create new BTRFS partition"
        echo "   3. Install RandhawaOS on BTRFS"
        echo "   4. Configure dual-boot"
        echo ""
        echo "❌ NOT IMPLEMENTED - Requires manual partitioning"
        echo "🔗 Manual guide: https://wiki.archlinux.org/title/Dual_boot_with_Windows"
        ;;
esac

echo ""
echo "📚 For now, let's set up BTRFS tools and snapper:"

# Install BTRFS tools
echo "📦 Installing BTRFS utilities..."
if command -v pacman &> /dev/null; then
    sudo pacman -S --needed btrfs-progs snapper snap-pac
elif command -v apt &> /dev/null; then
    sudo apt install btrfs-progs snapper
fi

# Create BTRFS subvolume simulation on existing filesystem
echo "🔧 Creating BTRFS-like directory structure..."
mkdir -p "$HOME/.local/share/randhawa-os/subvolumes"
mkdir -p "$HOME/.local/share/randhawa-os/snapshots"

echo "📝 Creating snapshot management script..."
cat > "$RANDHAWA_DIR/snapshot.sh" << 'EOF'
#!/bin/bash
# Simple snapshot management for RandhawaOS

SNAPSHOT_DIR="$HOME/.local/share/randhawa-os/snapshots"
CONFIG_DIR="$HOME/.config"
DOTFILES_DIR="$HOME/.local/share/randhawa-os/dotfiles"

mkdir -p "$SNAPSHOT_DIR"

case "$1" in
    create)
        DATE=$(date +%Y%m%d_%H%M%S)
        SNAPSHOT_NAME="randhawa_$DATE"
        
        echo "📸 Creating snapshot: $SNAPSHOT_NAME"
        
        # Copy current configs
        mkdir -p "$SNAPSHOT_DIR/$SNAPSHOT_NAME"
        cp -r "$CONFIG_DIR" "$SNAPSHOT_DIR/$SNAPSHOT_NAME/"
        
        # Save package list
        pacman -Qe > "$SNAPSHOT_DIR/$SNAPSHOT_NAME/packages.txt"
        
        # Save system info
        cat > "$SNAPSHOT_DIR/$SNAPSHOT_NAME/system_info.txt" << EOL
Date: $(date)
Kernel: $(uname -r)
Hostname: $(hostname)
Uptime: $(uptime)
EOL
        
        echo "✅ Snapshot created: $SNAPSHOT_DIR/$SNAPSHOT_NAME"
        ;;
    list)
        echo "📋 Available snapshots:"
        ls -la "$SNAPSHOT_DIR/"
        ;;
    restore)
        if [ -z "$2" ]; then
            echo "❌ Usage: $0 restore <snapshot_name>"
            exit 1
        fi
        
        if [ ! -d "$SNAPSHOT_DIR/$2" ]; then
            echo "❌ Snapshot not found: $2"
            exit 1
        fi
        
        echo "🔄 Restoring snapshot: $2"
        
        # Backup current config
        DATE=$(date +%Y%m%d_%H%M%S)
        mv "$CONFIG_DIR" "$CONFIG_DIR.backup_$DATE"
        
        # Restore config
        cp -r "$SNAPSHOT_DIR/$2/.config" "$HOME/"
        
        echo "✅ Snapshot restored: $2"
        echo "📁 Previous config backed up to: $CONFIG_DIR.backup_$DATE"
        ;;
    *)
        echo "Usage: $0 {create|list|restore <name>}"
        exit 1
        ;;
esac
EOF

chmod +x "$RANDHAWA_DIR/snapshot.sh"

echo "✅ BTRFS migration preparation completed!"
echo ""
echo "📋 Next steps:"
echo "1. Run: $RANDHAWA_DIR/snapshot.sh create"
echo "2. Test snapshot functionality"
echo "3. Plan actual BTRFS migration when ready"
echo ""
echo "🔗 Resources:"
echo "- Arch Wiki BTRFS: https://wiki.archlinux.org/title/Btrfs"
echo "- Snapper: https://wiki.archlinux.org/title/Snapper"
echo "- BTRFS conversion: https://btrfs.readthedocs.io/en/latest/btrfs-convert.html"