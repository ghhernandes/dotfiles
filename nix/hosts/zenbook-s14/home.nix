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
    ai
  ];

  # Fresh install on NixOS 26.05, so adopt the 26.05 home-manager defaults
  # (the shared common.nix baseline of 25.11 covers the older hosts).
  home.stateVersion = "26.05";

  # The panel is 1920x1200 in 300x190mm (~162 DPI), so scale 1 draws text at
  # ~60% of the size toolkits assume at 96 DPI. 1.25 divides cleanly (logical
  # 1536x960, ~130 DPI effective) and still leaves 768px per window in a
  # side-by-side split. XWayland clients get compositor-upscaled and lose some
  # sharpness, but NIXOS_OZONE_WL puts Electron and Chrome on native Wayland,
  # so the X11 holdouts here are occasional apps (GIMP, yubioath-flutter).
  #
  # Externals auto-configure on hotplug and extend *above* the laptop panel
  # (auto-up). Match each by its stable `description:` (from
  # `hyprctl monitors all`):
  #   personal 4K  -> scale 2 (logical 1920x1080)
  #   work FHD/2K  -> scale 1
  # Fill in the work rule below once captured; until then the wildcard lights
  # up any unknown external above the laptop at scale 1.
  wayland.windowManager.hyprland.settings.monitor = lib.mkForce [
    "eDP-1,1920x1200@60,auto,1.25"

    # Personal 4K (Alienware AW3225QF): above the laptop, scale 2 (sharp).
    "desc:Dell Inc. AW3225QF HDPCYZ3,preferred,auto-up,2"
    # "desc:<WORK_MONITOR_DESCRIPTION>,preferred,auto-up,1"

    ",preferred,auto-up,1"
  ];
}
