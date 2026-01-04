{ config, pkgs, ... }:

{
  imports = [
    ./hyprland.nix
    ./waybar.nix
    ./dunst.nix
    ./hyprlock.nix
  ];
}
