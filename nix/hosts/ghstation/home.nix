{ self, ... }:

{
  imports = with self.homeModules; [
    common
    cli
    cliHardware
    gui
    #emacs
    kitty
    fonts
    localBin
    dev
    hyprland
    rofi
    ai
  ];
}
