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