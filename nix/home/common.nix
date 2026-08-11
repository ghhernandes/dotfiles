# common.nix file is to define the baseline environment
# that must exists on every single machine

# use profiles/ to create group of different modules.
# Eg: server, homelab, etc.

{
  pkgs,
  lib,
  ...
}:

{
  home.packages = [ pkgs.nodejs ];

  nixpkgs.config = {
    allowUnfree = true;
    allowUnfreePredicate = _: true;
  };

  home = {
    # username and homeDirectory are set per-host in hosts/default.nix.
    # Baseline reflects the older hosts' install; newer hosts override per-host
    # (a machine's stateVersion should match when it was first set up).
    stateVersion = lib.mkDefault "25.11";
  };

  programs.home-manager.enable = true;
}
