# RandhawaOS

A declarative, reproducible desktop environment management system built on immutable infrastructure principles.

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![POSIX Compliant](https://img.shields.io/badge/POSIX-Compliant-green)](https://pubs.opengroup.org/onlinepubs/9699919799/)
[![OCI Compatible](https://img.shields.io/badge/OCI-Compatible-blue)](https://opencontainers.org/)

## 📋 Overview

RandhawaOS is a comprehensive system for achieving deterministic desktop environment reproduction across heterogeneous Linux distributions. It implements a dual-layer architecture combining cutting-edge user experience with long-term system stability through automated state management and cross-platform compatibility.

### 🏗️ Architecture

The system employs a layered approach to desktop environment management:

- **Immutable Base Layer**: Core system components with version pinning
- **Mutable Experience Layer**: User-space applications and configurations
- **Automation Layer**: Event-driven backup and synchronization services
- **Reproducibility Layer**: Cross-platform bootstrapping and restoration

## ⚡ Quick Start

### One-Command Installation
```bash
curl -fsSL https://raw.githubusercontent.com/prabhchintan/RandhawaOS/main/install.sh | bash
```

### Manual Installation
```bash
git clone https://github.com/prabhchintan/RandhawaOS.git
cd RandhawaOS
chmod +x bootstrap.sh
./bootstrap.sh
```

## 🔧 Core Components

### Package Management Strategy
- **Primary Package Manager**: Distribution-native (pacman, apt, dnf, zypper)
- **Reproducible Dependencies**: Nix package manager integration
- **Sandboxed Applications**: Flatpak runtime environment
- **Containerized Services**: Docker/Podman isolation

### Desktop Environment Stack
- **Compositor**: Hyprland (Wayland-native)
- **Status Bar**: Waybar with custom modules
- **Terminal Emulator**: Kitty with GPU acceleration
- **Application Launcher**: Rofi (Wayland fork)
- **Notification Daemon**: Dunst
- **File Manager**: Dolphin with KDE integration

### Automation Infrastructure
- **Event Monitoring**: inotify-based file system watching
- **Scheduled Operations**: systemd user timers
- **State Synchronization**: Git-based version control
- **Cross-Platform Compatibility**: POSIX shell scripting

## 🛠️ System Management

### Command Interface
```bash
# System status and health monitoring
randhawa-os status

# Manual state backup operations
randhawa-os snapshot create
randhawa-os snapshot list
randhawa-os snapshot restore <snapshot-id>

# Container management
randhawa-os container build
randhawa-os container run <environment>

# Configuration export/import
randhawa-os export
randhawa-os import <configuration-file>

# Filesystem migration utilities
randhawa-os migrate
```

### Automated Operations

#### Scheduled Backups
- **Frequency**: Every 6 hours (00:00, 06:00, 12:00, 18:00 UTC)
- **Boot-time**: 5 minutes post-boot initialization
- **Event-driven**: Real-time configuration change detection

#### Monitored Components
- System configuration files (Hyprland, Waybar, Kitty, etc.)
- Package installation state and versions
- Service enablement and configuration
- User dotfiles and SSH public keys
- Hardware-specific settings

## 📦 Reproducibility Features

### Cross-Platform Compatibility

| Distribution | Bootstrap | Containers | Nix | Package Manager | Status |
|-------------|-----------|------------|-----|-----------------|--------|
| Arch Linux  | ✅        | ✅         | ✅  | pacman         | Primary |
| Debian      | ✅        | ✅         | ✅  | apt            | Tested  |
| Ubuntu      | ✅        | ✅         | ✅  | apt            | Tested  |
| Fedora      | ✅        | ✅         | ✅  | dnf            | Tested  |
| openSUSE    | ✅        | ✅         | ✅  | zypper         | Tested  |
| NixOS       | ✅        | ✅         | ✅  | nix            | Native  |
| Alpine      | ✅        | ✅         | ✅  | apk            | Minimal |

### State Manifests

#### System Manifest Structure
```json
{
  "randhawa_os": {
    "version": "1.0.0",
    "base_system": "arch",
    "kernel": "linux 6.15.5.arch1-1",
    "architecture": "x86_64"
  },
  "packages": {
    "explicit": ["package-name version"],
    "aur": ["aur-package version"],
    "flatpak": ["app.domain.Name"]
  },
  "services": {
    "enabled": ["service-name"],
    "user_services": ["user-service"]
  }
}
```

### Restoration Methods

#### Emergency Recovery
```bash
# Minimal dependency restoration
curl -fsSL https://raw.githubusercontent.com/prabhchintan/RandhawaOS/main/emergency-restore.sh | bash
```

#### Full System Restoration
```bash
git clone https://github.com/prabhchintan/RandhawaOS.git
cd RandhawaOS
./restore.sh
```

## 🐳 Container Infrastructure

### Desktop Environment Containerization
```yaml
# docker-compose.yml excerpt
services:
  desktop:
    build: ./containers/desktop
    volumes:
      - /tmp/.X11-unix:/tmp/.X11-unix
      - $HOME/.config:/home/randhawa/.config:ro
    environment:
      - DISPLAY=$DISPLAY
      - WAYLAND_DISPLAY=$WAYLAND_DISPLAY
    privileged: true
    network_mode: host
```

### Development Environment
- Isolated toolchain environments
- Language-specific containers (Node.js, Python, Go, Rust)
- IDE integration with host filesystem
- Port forwarding for development servers

## 🔒 Security Model

### Data Protection
- **Private Key Exclusion**: SSH private keys never backed up
- **Credential Isolation**: Git credentials stored with 600 permissions
- **Configuration Sanitization**: Automatic sensitive data filtering
- **Access Control**: User-space service isolation

### Backup Security
- Public SSH keys only (`.pub` files)
- Configuration templates without secrets
- Environment variable substitution for sensitive values
- Repository access through encrypted credential storage

## 🚀 Installation Requirements

### Minimum System Requirements
- Linux kernel 5.4+ with Wayland support
- 4GB RAM (8GB recommended)
- 20GB available disk space
- Network connectivity for package downloads

### Supported Hardware
- Intel/AMD x86_64 processors
- Intel/AMD/NVIDIA graphics (Wayland compatible)
- Standard PC hardware with Linux driver support

### Dependencies
- `git` (version control operations)
- `curl`/`wget` (network operations)
- `systemd` (service management)
- `inotify-tools` (file system monitoring)

## 📁 Repository Structure

```
RandhawaOS/
├── bootstrap.sh              # Universal installation script
├── install.sh                # Streamlined installer
├── randhawa-os               # Primary management interface
├── manifests/                # System state definitions
│   ├── system-manifest.json
│   └── package-versions.txt
├── scripts/                  # Utility and setup scripts
│   ├── setup-nix.sh
│   ├── setup-containers.sh
│   └── migrate-btrfs.sh
├── containers/               # Container definitions
│   ├── desktop/
│   ├── development/
│   └── docker-compose.yml
├── configs/                  # Configuration templates
│   ├── hypr/
│   ├── waybar/
│   └── kitty/
└── docs/                     # Technical documentation
    ├── installation.md
    ├── architecture.md
    └── troubleshooting.md
```

## 🔧 Advanced Configuration

### Custom Package Sets
Add distribution-specific packages to manifests:
```bash
# Arch Linux
echo "custom-package version" >> manifests/packages-arch.txt

# Debian/Ubuntu  
echo "custom-package version" >> manifests/packages-debian.txt
```

### Service Configuration
Extend systemd service definitions:
```bash
# Add custom user service
cp custom.service ~/.config/systemd/user/
systemctl --user enable custom.service
```

### Container Customization
Modify container definitions in `containers/` directory and rebuild:
```bash
randhawa-os container build
```

## 📊 Performance Characteristics

### Resource Utilization
- **Storage Overhead**: ~1MB for core scripts
- **Memory Usage**: <50MB for monitoring services
- **Network Usage**: Minimal (backup operations only)
- **CPU Impact**: Negligible during normal operation

### Backup Performance
- **Configuration Backup**: <1 second
- **Package List Generation**: 1-3 seconds
- **Git Operations**: 2-5 seconds (network dependent)
- **Full Cycle**: Typically <10 seconds

## 🐛 Troubleshooting

### Common Issues

**Service Startup Failures**
```bash
# Check service status
systemctl --user status randhawa-backup.timer
systemctl --user status randhawa-watcher.service

# Restart services
systemctl --user restart randhawa-backup.timer
```

**Network Connectivity**
```bash
# Test GitHub access
git ls-remote https://github.com/prabhchintan/RandhawaOS.git

# Verify credentials
cat ~/.git-credentials  # Should show encoded credentials
```

**Path Issues**
```bash
# Add to shell profile
echo 'export PATH="$HOME/.local/share/randhawa-os:$PATH"' >> ~/.bashrc
```

### Debugging
Enable verbose logging:
```bash
# Monitor backup operations
journalctl --user -u randhawa-backup -f

# Watch configuration changes
journalctl --user -u randhawa-watcher -f
```

## 🤝 Contributing

### Development Setup
1. Fork the repository
2. Create feature branch
3. Test across multiple distributions
4. Ensure POSIX compatibility
5. Submit pull request

### Testing Protocol
- Verify bootstrap script on clean installations
- Test container builds across platforms
- Validate restoration procedures
- Check security scanning results

## 📄 License

MIT License. See [LICENSE](LICENSE) for full terms.

## 🔗 References

- [Wayland Protocol Specification](https://wayland.freedesktop.org/docs/html/)
- [systemd Service Management](https://systemd.io/)
- [Nix Package Manager](https://nixos.org/)
- [Open Container Initiative](https://opencontainers.org/)
- [POSIX Standards](https://pubs.opengroup.org/onlinepubs/9699919799/)

---

**RandhawaOS** - Deterministic Desktop Environment Management