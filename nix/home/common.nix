# common.nix file is to define the baseline environment
# that must exists on every single machine

# use profiles/ to create group of different modules.
# Eg: server, homelab, etc.

{
  lib,
  pkgs,
  ...
}:

{
  home.packages = [ pkgs.nodejs ];
  nixpkgs.config = {
    allowUnfree = true;
    allowUnfreePredicate = _: true;
  };

  home = {
    # username and homeDirectory are set per-host in hosts/default.nix
    stateVersion = "25.11";
  };

  programs.home-manager.enable = true;
}
