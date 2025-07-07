# RandhawaOS Installation Guide

## Quick Install

### One-Line Installation
```bash
curl -fsSL https://raw.githubusercontent.com/your-username/RandhawaOS/main/bootstrap.sh | bash
```

### Manual Installation
```bash
git clone https://github.com/your-username/RandhawaOS.git
cd RandhawaOS
chmod +x bootstrap.sh
./bootstrap.sh
```

## System Requirements

- Linux distribution (Arch, Debian, Ubuntu, Fedora, openSUSE)
- 4GB+ RAM
- 20GB+ free disk space
- Modern GPU (Intel/AMD/NVIDIA) for Wayland

## Supported Distributions

| Distribution | Status | Notes |
|-------------|--------|-------|
| Arch Linux | ✅ Primary | Native support |
| Debian | ✅ Tested | Stable branch recommended |
| Ubuntu | ✅ Tested | 20.04+ required |
| Fedora | ✅ Tested | Recent versions |
| openSUSE | ✅ Tested | Tumbleweed/Leap |
| NixOS | ✅ Native | Uses Nix directly |

## Post-Installation

1. **Reboot** to apply group changes
2. **Check status**: `randhawa-os status`
3. **Build containers**: `randhawa-os container build`
4. **Create snapshot**: `randhawa-os snapshot create`

## Troubleshooting

### Common Issues

**Permission denied errors**
```bash
sudo usermod -aG docker $USER
# Then logout and login again
```

**Missing packages**
```bash
# Update package databases first
sudo pacman -Sy  # Arch
sudo apt update  # Debian/Ubuntu
```

**Container build fails**
```bash
# Ensure Docker is running
sudo systemctl start docker
```

For more help, see [troubleshooting.md](troubleshooting.md)