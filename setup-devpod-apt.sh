#!/bin/bash

export XDG_CONFIG_HOME="$HOME/.config"
mkdir -p "$XDG_CONFIG_HOME"

ln -sf "$PWD/nvim" "$XDG_CONFIG_HOME/nvim"
ln -sf "$PWD/tmux" "$XDG_CONFIG_HOME/tmux"

packages=(
    ripgrep
    fzf
    tmux
    neovim
)

for package in "${packages[@]}"; do
        echo "Installing $package..."
        apt-get install -y "$package"
done

# Neovim Package manager
git clone --depth 1 https://github.com/wbthomason/packer.nvim\
 ~/.local/share/nvim/site/pack/packer/start/packer.nvim