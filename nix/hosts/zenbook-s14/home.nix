{ self, ... }:

{
  imports = with self.homeModules; [
    common
    cli
    git
    zsh
    cliHardware
    gui
    kitty
    fonts
    dev
    plasma
    ai
    reverseEngineering
  ];

  # Fresh install on NixOS 26.05, so adopt the 26.05 home-manager defaults
  # (the shared common.nix baseline of 25.11 covers the older hosts).
  home.stateVersion = "26.05";
}
