{ pkgs, ... }:

{
  services.desktopManager.plasma6.enable = true;
  services.displayManager.sddm = {
    enable = true;
    wayland.enable = true;
  };

  # Electron and Chromium apps render on native Wayland instead of blurry
  # XWayland.
  environment.sessionVariables.NIXOS_OZONE_WL = "1";

  # gsettings/dconf backend for GTK apps running under Plasma.
  programs.dconf.enable = true;

  # Trash, MTP (phones) and network shares for GTK apps; udisks2 is the mount
  # backend behind Plasma's Disks & Devices applet.
  services.gvfs.enable = true;
  services.udisks2.enable = true;

  environment.systemPackages = [ pkgs.wl-clipboard ];
}
