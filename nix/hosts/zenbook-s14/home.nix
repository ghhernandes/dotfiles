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

  # Integer scale (1x) keeps XWayland apps (e.g. Spotify) crisp — fractional
  # scales bitmap-upscale X clients and blur them. Tradeoff: 1920x1200 on a
  # 14" panel (~162 DPI) is on the small side.
  #
  # Externals auto-configure on hotplug and extend *above* the laptop panel
  # (auto-up). Match each by its stable `description:` (from
  # `hyprctl monitors all`) and use an integer scale so XWayland stays sharp:
  #   personal 4K  -> scale 2 (logical 1920x1080)
  #   work FHD/2K  -> scale 1
  # Fill in the two desc rules below once captured; until then the wildcard
  # lights up any unknown external above the laptop at scale 1.
  wayland.windowManager.hyprland.settings.monitor = lib.mkForce [
    "eDP-1,1920x1200@60,auto,1"

    # Personal 4K (Alienware AW3225QF): above the laptop, scale 2 (sharp).
    "desc:Dell Inc. AW3225QF HDPCYZ3,preferred,auto-up,2"
    # "desc:<WORK_MONITOR_DESCRIPTION>,preferred,auto-up,1"

    ",preferred,auto-up,1"
  ];
}
