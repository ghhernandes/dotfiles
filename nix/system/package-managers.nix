{ config, pkgs, ... }:

{
  programs.appimage.enable = true;
  services.flatpak.enable = true;
}
