{ config, pkgs, inputs, system, ... }:

{
  imports = [ ../../home-manager/home.nix ];

  home.packages = with pkgs; [
    inputs.claude-desktop.packages.${system}.claude-desktop
  ];
}
