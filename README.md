## Workstation setup

### Fedora Workstation

```bash

dnf update -y

# i3 desktop dependencies

dnf install i3 vim tmux kitty picom feh

# common dependencies

dnf install vim tmux fzf htop btop pavucontrol

# RPM fusion nonfree and free setup

dnf install https://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm /
dnf install https://download1.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm
dnf update -y

# NVIDIA setup

dnf install akmod-nvidia
dnf mark install akmod-nvidia
dnf install xorg-x11-drv-nvidia-cuda-libs
```

### Dotfiles

```bash
mkdir -p ~/projects/ghhernandes

git clone git@github.com:ghhernandes/dotfiles.git ~/projects/ghhernandes

cp -a bashrc $HOME/.bashrc
cp -a bash_profile $HOME/.bash_profile

cp -a ~/projects/ghhernandes/dotfiles/i3 $HOME/.config
cp -a ~/projects/ghhernandes/dotfiles/nvim $HOME/.config
cp -a ~/projects/ghhernandes/dotfiles/tmux $HOME/.config
cp -a ~/projects/ghhernandes/dotfiles/scripts $HOME/.config
```

### Neovim

```bash
# common dependencies
dnf -y install ninja-build cmake gcc make unzip gettext curl glibc-gconv-extra golang-bin nodejs

git clone git@github.com:neovim/neovim.git

make CMAKE_BUILD_TYPE=Release
make install
```
