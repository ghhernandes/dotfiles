{ self, config, pkgs, ... }:

{
  imports = with self.homeModules; [
    common
    cli
    gui
    emacs
    kitty
    localBin
    dev
    hyprland
    rofi
  ];
}
