{ self, ... }:

{
  imports = with self.homeModules; [
    common
    cli
    zsh
    cliHardware
    gui
    #emacs
    kitty
    fonts
    localBin
    dev
    hyprland
    rofi
    claude
    opencode
    gemini
  ];
}
