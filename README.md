# RandhawaOS

**A Complete, Reproducible Desktop Environment That Lives in Git**

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![POSIX Compliant](https://img.shields.io/badge/POSIX-Compliant-green)](https://pubs.opengroup.org/onlinepubs/9699919799/)
[![Cross Platform](https://img.shields.io/badge/Platform-Linux-blue)](https://www.linux.org/)

> *"Your entire desktop environment, applications, and configurations automatically backed up and synchronized across all your computers"*

---

## 🤔 What is RandhawaOS?

RandhawaOS transforms your Linux computer into a **reproducible, version-controlled desktop environment**. Think of it as "your desktop as code" - where every setting, application, and configuration is automatically tracked, backed up, and can be perfectly recreated on any Linux computer.

### The Problem It Solves

**Traditional Desktop Setup Issues:**
- 😫 Setting up a new computer takes hours/days
- 💔 Losing work when a computer crashes  
- 🔄 Keeping multiple computers in sync is painful
- 🎯 Hard to reproduce exact same environment
- 📱 No version control for your desktop

**RandhawaOS Solution:**
- ⚡ **One Command Setup**: Get your complete environment on any Linux machine
- 🔄 **Automatic Sync**: Changes automatically backed up to GitHub every 10 minutes  
- 🖥️ **Multi-Computer**: Use the same setup across unlimited computers
- 📸 **Time Travel**: Create snapshots and restore to any previous state
- 🐳 **Bulletproof**: Container-based isolation for maximum stability

---

## 🚀 Quick Start (2 Minutes)

### Step 1: Fork This Repository
1. Click **Fork** button on this GitHub page
2. This creates YOUR personal copy where your settings will be saved

### Step 2: One-Command Installation
```bash
# Replace YOUR-USERNAME with your GitHub username
curl -fsSL https://raw.githubusercontent.com/YOUR-USERNAME/RandhawaOS/main/install.sh | bash
```

### Step 3: Authenticate with GitHub
During installation, you'll be prompted for GitHub credentials:
- **Username**: Your GitHub username  
- **Password**: Use a [Personal Access Token](https://github.com/settings/tokens) (not your GitHub password)

**That's it!** Your desktop is now automatically backed up every 10 minutes.

---

## 📱 What You Get

### 🖥️ Modern Desktop Environment
- **Hyprland**: Lightning-fast Wayland compositor with GPU acceleration
- **Waybar**: Beautiful status bar with system information
- **Kitty**: GPU-accelerated terminal with ligature support
- **Rofi**: Elegant application launcher and window switcher
- **Dunst**: Clean notification system

### 📦 Smart Package Management
- **Native Packages**: Uses your distro's package manager (pacman, apt, dnf, etc.)
- **Nix Packages**: Reproducible packages that won't break your system
- **Flatpak Apps**: Sandboxed applications for security
- **Containers**: Isolated development environments

### 🔄 Automatic Everything
- **Backup**: Every configuration change automatically saved to GitHub
- **Sync**: Multiple computers stay perfectly synchronized  
- **Recovery**: Restore your complete environment on any Linux machine
- **Snapshots**: Create restore points for safe experimentation

---

## 🌍 Universal Linux Support

RandhawaOS works on **any modern Linux distribution**:

| Distribution | Status | Package Manager | Notes |
|-------------|--------|-----------------|-------|
| **Arch Linux** | ✅ Primary | pacman + AUR | Full featured, recommended |
| **Ubuntu** | ✅ Tested | apt | Complete support |
| **Debian** | ✅ Tested | apt | Complete support |
| **Fedora** | ✅ Tested | dnf | Complete support |
| **openSUSE** | ✅ Tested | zypper | Complete support |
| **NixOS** | ✅ Native | nix | Full integration |
| **Others** | ✅ Basic | varies | Core features work |

**System Requirements:**
- Linux kernel 5.4+ with Wayland support
- 4GB RAM (8GB recommended for containers)
- 20GB free disk space
- Internet connection for packages and sync

---

## 🛠️ Daily Usage

Once installed, RandhawaOS works transparently in the background. Here's what you can do:

### Command Interface
```bash
# Check system status
randhawa-os status

# Create a snapshot before making changes
randhawa-os snapshot create

# View all available snapshots
randhawa-os snapshot list

# Restore to a previous snapshot
randhawa-os snapshot restore snapshot_20250107_143022

# Build development containers
randhawa-os container build

# Export your configuration for sharing
randhawa-os export
```

### Automatic Operations
- **⏰ Scheduled Backups**: Every 6 hours (customizable)
- **🔍 Change Detection**: Monitors config files and triggers immediate backup
- **🔄 Git Sync**: Pushes changes to your GitHub repository automatically
- **📊 System Monitoring**: Tracks packages, services, and hardware changes

---

## 🏗️ How It Works (Technical Overview)

### Architecture
RandhawaOS uses a **layered architecture** for maximum reliability:

```
┌─────────────────────────────────────────┐
│ User Experience Layer (Hyprland+Apps)  │
├─────────────────────────────────────────┤
│ Automation Layer (Git Sync + Monitoring)│
├─────────────────────────────────────────┤
│ Package Layer (Native+Nix+Flatpak)     │
├─────────────────────────────────────────┤
│ Container Layer (Docker/Podman)        │
├─────────────────────────────────────────┤
│ Base System (Any Linux Distribution)   │
└─────────────────────────────────────────┘
```

### What Gets Backed Up
- **Configuration Files**: All dotfiles and app configs
- **Package Lists**: Complete inventory of installed software
- **System State**: Services, hardware info, performance metrics
- **Security**: SSH public keys only (private keys never backed up)

### File Structure
```
~/.local/share/randhawa-os/
├── auto-backup.sh         # Automatic backup engine
├── snapshot.sh           # Manual snapshot management  
├── containers/           # Docker container definitions
├── snapshots/           # Local system snapshots
└── dotfiles/           # Configuration backups

Your GitHub Repository:
├── configs/             # Desktop environment configs
├── containers/         # Development environment containers
├── manifests/         # System state tracking
├── scripts/           # Setup and utility scripts
└── randhawa-os        # Main command interface
```

---

## 🔄 Multi-Computer Setup

**You can use RandhawaOS on unlimited computers!** Each computer automatically syncs to your GitHub repository.

### Setting Up Additional Computers
1. **Same Installation**: Run the same curl command on the new computer
2. **Same Authentication**: Use the same GitHub token
3. **Automatic Sync**: Both computers will sync changes with each other

### How Sync Works
- **Computer A** makes a change → automatically pushed to GitHub
- **Computer B** pulls changes every 6 hours (or manually)
- **No Conflicts**: Git handles merging automatically
- **Independent Schedules**: Each computer backs up on its own timer

### Example Workflow
```bash
# On Computer A: Install new software
sudo pacman -S firefox
# → Automatically backed up to GitHub in 10 minutes

# On Computer B: Pull latest changes  
cd ~/RandhawaOS-GitHub && git pull
# → Firefox package will be installed automatically
```

---

## 🐳 Container Support

RandhawaOS includes **development containers** for isolated, reproducible environments:

### Built-in Containers
- **Desktop Container**: Complete desktop environment in isolation
- **Development Container**: Multi-language dev environment (Node.js, Python, Go, Rust)
- **Browser Container**: Isolated web browsing for security

### Usage Examples
```bash
# Build all containers
randhawa-os container build

# Run development environment
randhawa-os container run development

# Start complete containerized desktop
randhawa-os container run desktop
```

### Benefits
- **Isolation**: Experiment without affecting your main system
- **Reproducibility**: Same environment on every computer
- **Security**: Sandboxed applications can't access your files
- **Legacy Support**: Run older software in containers

---

## 📸 Snapshot System

Create **restore points** before making major changes:

```bash
# Create snapshot before installing new software
randhawa-os snapshot create

# List all snapshots
randhawa-os snapshot list
# Output:
# 📋 Available snapshots:
# randhawa_20250107_143022 (before steam install)
# randhawa_20250107_120000 (fresh install)

# Restore to previous state
randhawa-os snapshot restore randhawa_20250107_120000
```

**What Snapshots Include:**
- Complete configuration files
- Package lists for restoration
- System state information
- Hardware and service configuration

**Storage & Recovery:**
- Snapshots stored locally for quick restore
- Automatically backed up to GitHub for disaster recovery
- Sensitive data (passwords, keys) filtered out during backup

---

## 🚨 Disaster Recovery

### Complete System Loss Recovery
If your computer dies, restore everything on a new Linux machine:

```bash
# Emergency restore (minimal dependencies)
curl -fsSL https://raw.githubusercontent.com/YOUR-USERNAME/RandhawaOS/main/emergency-restore.sh | bash

# Full restoration with all features
git clone https://github.com/YOUR-USERNAME/RandhawaOS.git
cd RandhawaOS  
./restore.sh
```

### What Gets Restored
- **All Applications**: Every package automatically reinstalled
- **All Configurations**: Desktop looks and behaves identically
- **All Dotfiles**: Shell aliases, vim configs, etc.
- **System Services**: Same services enabled/disabled
- **Development Environment**: Containers and dev tools ready
- **System Snapshots**: Previous restore points available for rollback

---

## 🔒 Security & Privacy

### What's Protected
- **Private Keys**: SSH private keys never backed up (only .pub files)
- **Passwords**: No passwords or secrets stored in repository
- **Personal Data**: Only configuration files backed up
- **Credentials**: Git authentication stored locally with encryption

### Security Features  
- **Public Repository Safe**: Your repo can be public - no secrets exposed
- **Credential Isolation**: GitHub tokens stored with restricted permissions
- **Container Isolation**: Untrusted software runs in containers
- **Selective Backup**: Automatic filtering of sensitive files

---

## 🛟 Troubleshooting

### Authentication Issues
```bash
# Check if GitHub authentication is working
git ls-remote https://github.com/YOUR-USERNAME/RandhawaOS.git

# Update credentials if needed
git config --global credential.helper store
git push  # Enter username and Personal Access Token
```

### Backup Not Working
```bash
# Check backup service status
systemctl --user status randhawa-backup.timer

# Check recent backup logs
journalctl --user -u randhawa-backup.service | tail -20

# Force manual backup
~/.local/share/randhawa-os/auto-backup.sh
```

### Missing Commands
```bash
# Add RandhawaOS to your PATH
echo 'export PATH="$HOME/.local/share/randhawa-os:$PATH"' >> ~/.bashrc
source ~/.bashrc
```

### Container Issues
```bash
# Rebuild containers after changes
randhawa-os container build

# Check Docker service
sudo systemctl status docker
```

---

## 🎯 Advanced Usage

### Custom Package Lists
Add your own software to automatic installation:

```bash
# Arch Linux packages
echo "your-package" >> manifests/packages-explicit-current.txt

# Flatpak applications  
echo "com.example.YourApp" >> manifests/packages-flatpak-current.txt
```

### Custom Configurations
```bash
# Add your own configs to be tracked
cp ~/.config/your-app/config ~/.local/share/randhawa-os/dotfiles/
```

### Custom Services
```bash
# Add systemd services to auto-enable
echo "your-service.service" >> manifests/services-enabled.txt
```

---

## 🤝 Contributing

### For Users
1. **Fork** this repository to create your personal version
2. **Customize** configurations for your preferences  
3. **Share** interesting configurations via pull requests

### For Developers
1. **Test** on multiple Linux distributions
2. **Ensure** POSIX shell script compatibility
3. **Verify** security: no secrets in configurations
4. **Submit** pull requests with improvements

### Testing New Features
```bash
# Create snapshot before testing
randhawa-os snapshot create

# Test new features...

# Restore if something breaks
randhawa-os snapshot restore <snapshot-name>
```

---

## 📚 Learn More

### Philosophy
RandhawaOS implements **"Desktop as Code"** - treating your desktop environment like software:
- **Version Control**: Track every change
- **Reproducibility**: Identical environments everywhere  
- **Automation**: Eliminate manual setup
- **Reliability**: Quick recovery from any failure

### Technical Details
- **Immutable Infrastructure**: Core system never modified
- **Declarative Configuration**: Define desired state, system achieves it
- **Event-Driven Automation**: Responds to changes automatically
- **Multi-Layer Package Management**: Best tool for each use case

---

## 📄 License

MIT License - feel free to fork, modify, and share!

---

## 🔗 Quick Links

- **🍴 [Fork This Repository](https://github.com/prabhchintan/RandhawaOS/fork)**
- **🎫 [Create Personal Access Token](https://github.com/settings/tokens)**
- **📖 [Detailed Installation Guide](docs/installation.md)**
- **🐛 [Report Issues](https://github.com/prabhchintan/RandhawaOS/issues)**

---

**RandhawaOS** - *Your Desktop Environment, Everywhere, Always*

> *"Set up once, use everywhere, never lose your work again"*
