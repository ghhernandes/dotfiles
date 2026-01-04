# common.nix file is to define the baseline environment 
# that must exists on every single machine

# use profiles/ to create group of different modules.
# Eg: server, homelab, etc.

{ config, pkgs, lib, ... }:

{
  nixpkgs.config = {
    allowUnfree = true;
    allowUnfreePredicate = _: true;
  };

  home.username = lib.mkDefault "gh";
  home.homeDirectory = lib.mkDefault "/home/gh";
  home.stateVersion = "25.11";

  programs.home-manager.enable = true;

  home.packages = [
    pkgs.btop
    pkgs.fzf
    pkgs.tree
    pkgs.ripgrep
  ];
}
