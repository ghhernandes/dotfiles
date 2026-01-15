{ self, config, pkgs, ... }:

{
  imports = with self.homeModules; [
    common
    cli
    gui
    emacs
    kitty
    fonts
    localBin
    dev
    hyprland
    rofi
  ];
}
