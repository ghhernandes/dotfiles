{ config, pkgs, ... }:

{
  imports = [
    ./rofi.nix
    ./theme.nix
    ./scripts.nix
  ];
}
