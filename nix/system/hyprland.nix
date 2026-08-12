{ pkgs, ... }:

{
  # Enable Hyprland window manager
  programs.hyprland = {
    enable = true;
    withUWSM = true; # recommended for NixOS 24.11+
    xwayland.enable = true;
  };

  # Enable Wayland support for Electron apps
  environment.sessionVariables.NIXOS_OZONE_WL = "1";

  # XDG Portal for Hyprland. The GTK portal backend provides the file-chooser
  # and "settings" (dark-mode) interfaces that GTK apps expect.
  xdg.portal = {
    enable = true;
    extraPortals = [
      pkgs.xdg-desktop-portal-hyprland
      pkgs.xdg-desktop-portal-gtk
    ];
  };

  # gsettings/dconf backend — GTK apps (Nautilus, ...) need it to read theme
  # and preferences.
  programs.dconf.enable = true;

  # Make Nautilus a real file manager: gvfs adds mounting, trash, MTP (phones)
  # and network shares; udisks2 is the mount backend.
  services.gvfs.enable = true;
  services.udisks2.enable = true;

  # System packages for Hyprland functionality
  environment.systemPackages = [
    pkgs.grim # screenshot functionality
    pkgs.slurp # screenshot functionality
    pkgs.wl-clipboard # wl-copy and wl-paste for copy/paste from stdin/stdout
  ];
}
