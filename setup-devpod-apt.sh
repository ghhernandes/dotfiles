#!/bin/bash

export XDG_CONFIG_HOME="$HOME/.config"
mkdir -p "$XDG_CONFIG_HOME"

ln -sf "$PWD/nvim" "$XDG_CONFIG_HOME/nvim"
ln -sf "$PWD/tmux" "$XDG_CONFIG_HOME/tmux"

ARCH=$(uname -m)
if [ "$ARCH" = "x86_64" ]; then
    ARCH="x86_64"
elif [ "$ARCH" = "aarch64" ]; then
    ARCH="arm64"
else
    echo "Unsupported architecture: $ARCH"
    exit 1

fi

packages=(
    curl
    ripgrep
    fzf
    tmux
)

for package in "${packages[@]}"; do
        echo "Installing $package..."
        apt-get install -y "$package"
done

# Neovim AppImage (no FUSE required)

curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim-linux-$ARCH.appimage
chmod u+x nvim-linux-$ARCH.appimage

./nvim-linux-$ARCH.appimage --appimage-extract

mkdir -p /opt/nvim
mv squashfs-root /opt/nvim/nvim

ln -s /opt/nvim/nvim/AppRun /usr/local/bin/nvim

# Neovim Package Manager
git clone --depth 1 https://github.com/wbthomason/packer.nvim\
 ~/.local/share/nvim/site/pack/packer/start/packer.nvim