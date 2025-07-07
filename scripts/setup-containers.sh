#!/bin/bash
# Container setup for RandhawaOS

echo "🐳 Setting up containerization for RandhawaOS..."

RANDHAWA_DIR="/home/prab/.local/share/randhawa-os"
CONTAINERS_DIR="$RANDHAWA_DIR/containers"

# Create container directories
mkdir -p "$CONTAINERS_DIR/desktop"
mkdir -p "$CONTAINERS_DIR/apps"
mkdir -p "$CONTAINERS_DIR/dev"

# Install container tools
echo "📦 Installing container tools..."
if command -v pacman &> /dev/null; then
    sudo pacman -S --needed docker podman buildah skopeo flatpak
elif command -v apt &> /dev/null; then
    sudo apt install -y docker.io podman buildah skopeo flatpak
fi

# Add user to docker group
sudo usermod -aG docker $USER

# Enable Docker service
sudo systemctl enable docker
sudo systemctl start docker

# Setup Flatpak
flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo

# Create desktop environment container
echo "🖥️  Creating desktop container definition..."
cat > "$CONTAINERS_DIR/desktop/Dockerfile" << 'EOF'
FROM archlinux:latest

# Install desktop environment
RUN pacman -Syu --noconfirm && \
    pacman -S --noconfirm \
        hyprland \
        waybar \
        kitty \
        rofi-wayland \
        dunst \
        grim \
        slurp \
        wl-clipboard \
        pipewire \
        pipewire-pulse \
        wireplumber \
        gtk3 \
        gtk4 \
        qt5-wayland \
        qt6-wayland \
        xdg-desktop-portal-hyprland \
        xdg-desktop-portal-gtk

# Create user
RUN useradd -m -s /bin/bash randhawa && \
    usermod -aG audio,video,input randhawa

# Copy configurations
COPY hypr/ /home/randhawa/.config/hypr/
COPY waybar/ /home/randhawa/.config/waybar/
COPY kitty/ /home/randhawa/.config/kitty/

# Set ownership
RUN chown -R randhawa:randhawa /home/randhawa/

USER randhawa
WORKDIR /home/randhawa

# Start Hyprland
CMD ["hyprland"]
EOF

# Create development container
echo "💻 Creating development container..."
cat > "$CONTAINERS_DIR/dev/Dockerfile" << 'EOF'
FROM archlinux:latest

# Install development tools
RUN pacman -Syu --noconfirm && \
    pacman -S --noconfirm \
        base-devel \
        git \
        vim \
        code \
        nodejs \
        npm \
        python \
        python-pip \
        go \
        rust \
        docker \
        kubectl \
        terraform

# Create user
RUN useradd -m -s /bin/bash developer && \
    usermod -aG docker developer

# Install additional tools
RUN npm install -g @angular/cli @vue/cli create-react-app

USER developer
WORKDIR /home/developer

CMD ["/bin/bash"]
EOF

# Create app container template
echo "📱 Creating app container template..."
cat > "$CONTAINERS_DIR/apps/Dockerfile.template" << 'EOF'
FROM archlinux:latest

# Install app dependencies
RUN pacman -Syu --noconfirm && \
    pacman -S --noconfirm \
        APP_PACKAGES_HERE

# Create user
RUN useradd -m -s /bin/bash appuser

# Install app
RUN APP_INSTALL_COMMANDS_HERE

USER appuser
WORKDIR /home/appuser

CMD ["APP_COMMAND_HERE"]
EOF

# Create compose file for the stack
echo "🔗 Creating Docker Compose stack..."
cat > "$CONTAINERS_DIR/docker-compose.yml" << 'EOF'
version: '3.8'

services:
  desktop:
    build: ./desktop
    volumes:
      - /tmp/.X11-unix:/tmp/.X11-unix
      - $HOME/.config:/home/randhawa/.config:ro
      - /dev/dri:/dev/dri
      - /dev/snd:/dev/snd
    environment:
      - DISPLAY=$DISPLAY
      - WAYLAND_DISPLAY=$WAYLAND_DISPLAY
      - XDG_RUNTIME_DIR=/tmp/runtime-randhawa
    privileged: true
    network_mode: host
    
  development:
    build: ./dev
    volumes:
      - $HOME/Projects:/home/developer/Projects
      - /var/run/docker.sock:/var/run/docker.sock
    working_dir: /home/developer/Projects
    tty: true
    stdin_open: true
    
  web-browser:
    image: jlesage/firefox
    ports:
      - "5800:5800"
    volumes:
      - browser-config:/config
      - $HOME/Downloads:/config/downloads
    environment:
      - DISPLAY_WIDTH=1920
      - DISPLAY_HEIGHT=1080
    
volumes:
  browser-config:
EOF

# Create build script
echo "🔨 Creating build script..."
cat > "$CONTAINERS_DIR/build.sh" << 'EOF'
#!/bin/bash
# Build RandhawaOS containers

set -e

echo "🏗️  Building RandhawaOS containers..."

# Copy current configs to desktop container
mkdir -p desktop/hypr desktop/waybar desktop/kitty

if [ -d "$HOME/.config/hypr" ]; then
    cp -r "$HOME/.config/hypr/"* desktop/hypr/
fi

if [ -d "$HOME/.config/waybar" ]; then
    cp -r "$HOME/.config/waybar/"* desktop/waybar/
fi

if [ -d "$HOME/.config/kitty" ]; then
    cp -r "$HOME/.config/kitty/"* desktop/kitty/
fi

# Build containers
echo "📦 Building desktop container..."
docker build -t randhawa-os:desktop desktop/

echo "📦 Building development container..."
docker build -t randhawa-os:dev dev/

echo "✅ Containers built successfully!"
echo "🚀 To start the stack: docker-compose up -d"
EOF

chmod +x "$CONTAINERS_DIR/build.sh"

# Create run script
echo "🏃 Creating run script..."
cat > "$CONTAINERS_DIR/run.sh" << 'EOF'
#!/bin/bash
# Run RandhawaOS containers

case "$1" in
    desktop)
        echo "🖥️  Starting desktop container..."
        docker run -it --rm \
            --privileged \
            --net host \
            -v /tmp/.X11-unix:/tmp/.X11-unix \
            -v $HOME/.config:/home/randhawa/.config:ro \
            -v /dev/dri:/dev/dri \
            -v /dev/snd:/dev/snd \
            -e DISPLAY=$DISPLAY \
            -e WAYLAND_DISPLAY=$WAYLAND_DISPLAY \
            randhawa-os:desktop
        ;;
    dev)
        echo "💻 Starting development container..."
        docker run -it --rm \
            -v $HOME/Projects:/home/developer/Projects \
            -v /var/run/docker.sock:/var/run/docker.sock \
            randhawa-os:dev
        ;;
    stack)
        echo "🔗 Starting full stack..."
        docker-compose up -d
        ;;
    stop)
        echo "🛑 Stopping containers..."
        docker-compose down
        ;;
    *)
        echo "Usage: $0 {desktop|dev|stack|stop}"
        exit 1
        ;;
esac
EOF

chmod +x "$CONTAINERS_DIR/run.sh"

echo "✅ Container setup completed!"
echo ""
echo "📋 Next steps:"
echo "1. Restart shell or logout/login to apply group changes"
echo "2. Build containers: cd $CONTAINERS_DIR && ./build.sh"
echo "3. Test desktop container: ./run.sh desktop"
echo "4. Test development container: ./run.sh dev"
echo ""
echo "🔗 Container files created in: $CONTAINERS_DIR"