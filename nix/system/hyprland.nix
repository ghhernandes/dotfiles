{ config, pkgs, ... }:

{
  # Enable Hyprland window manager
  programs.hyprland = {
    enable = true;
    withUWSM = true;  # recommended for NixOS 24.11+
    xwayland.enable = true;
  };

  # Enable Wayland support for Electron apps
  environment.sessionVariables.NIXOS_OZONE_WL = "1";

  # XDG Portal for Hyprland
  xdg.portal = {
    enable = true;
    extraPortals = [ pkgs.xdg-desktop-portal-hyprland ];
  };

  # System packages for Hyprland functionality
  environment.systemPackages = [
    pkgs.grim           # screenshot functionality
    pkgs.slurp          # screenshot functionality
    pkgs.wl-clipboard   # wl-copy and wl-paste for copy/paste from stdin/stdout
  ];
}
