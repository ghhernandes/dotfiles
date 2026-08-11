{ self, lib, ... }:

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
    hyprland
    hypridle
    rofi
    claude
    opencode
    gemini
  ];

  # Built-in panel at 1.25x scale — 1920x1200 on a 14" panel is ~162 DPI,
  # too small at scale 1. 1.25 divides cleanly (logical 1536x960, no blur).
  # Wildcard entry auto-configures an external/dock monitor at scale 1.
  wayland.windowManager.hyprland.settings.monitor = lib.mkForce [
    "eDP-1,1920x1200@60,auto,1.25"
    ",preferred,auto,1"
  ];
}
