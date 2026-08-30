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
    reverseEngineering
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
  #   personal 4K  -> scale 1.5 (logical 2560x1440, QHD)
  #   work FHD/2K  -> scale 1
  # Fill in the work rule below once captured; until then the wildcard lights
  # up any unknown external above the laptop at scale 1.
  wayland.windowManager.hyprland.settings.monitor = lib.mkForce [
    "eDP-1,1920x1200@60,auto,1.25"

    # Personal 4K (Alienware AW3225QF): above the laptop, scale 1.5 (logical QHD).
    "desc:Dell Inc. AW3225QF HDPCYZ3,preferred,auto-up,1.5"
    # "desc:<WORK_MONITOR_DESCRIPTION>,preferred,auto-up,1"

    ",preferred,auto-up,1"
  ];

  # XWayland can't do fractional scaling itself, so at scale 1.25/1.5 it
  # renders X11 clients (GIMP, yubioath-flutter, Ghidra's Swing UI, ...) at 1x
  # and lets the compositor bilinear-upscale them, which blurs text.
  # force_zero_scaling tells XWayland to always render at 1x and let Hyprland
  # handle the scaling; pairing it with GDK_SCALE,2 makes GTK clients render
  # at 2x instead, so the compositor is downscaling a sharper source instead
  # of upscaling a blurry one. XCURSOR_SIZE is doubled to match, since the
  # cursor theme is drawn by the same 2x-then-downscale path.
  wayland.windowManager.hyprland.settings = {
    xwayland.force_zero_scaling = true;
    env = lib.mkAfter [
      "GDK_SCALE,2"
      "XCURSOR_SIZE,48"
    ];
  };
}
