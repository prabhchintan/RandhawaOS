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
COPY configs/hypr/ /home/randhawa/.config/hypr/
COPY configs/waybar/ /home/randhawa/.config/waybar/
COPY configs/kitty/ /home/randhawa/.config/kitty/

# Set ownership
RUN chown -R randhawa:randhawa /home/randhawa/

USER randhawa
WORKDIR /home/randhawa

# Start Hyprland
CMD ["hyprland"]