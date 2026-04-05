{ self, config, pkgs, lib, ... }:

{
  imports = with self.homeModules; [
    common
    cli
    localBin
    dev
  ];

  # Override the auto-detected username from directory name
  home.username = lib.mkForce "gh";
  home.homeDirectory = lib.mkForce "/home/gh";
}
