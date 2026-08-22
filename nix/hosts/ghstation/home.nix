{ self, lib, ... }:

{
  imports = with self.homeModules; [
    common
    cli
    git
    zsh
    cliHardware
    gui
    #emacs
    kitty
    fonts
    dev
    hyprland
    rofi
    ai
  ];

  wayland.windowManager.hyprland.settings.monitor = lib.mkForce [
    "DP-1,2560x1440@165,auto,1"
  ];
}
