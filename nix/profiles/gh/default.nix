{ self, config, pkgs, ... }:

{
  imports = with self.homeModules; [
    common
    cli
    tmux
    git
    neovim
    shell
    emacs
    kitty
    editors
    browsers
    media
    messaging
    passwordManager
    claudeCode
    localBin
    dev
    hyprland
    rofi
  ];
}
