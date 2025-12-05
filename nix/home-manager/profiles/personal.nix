{ config, pkgs, ... }:

{
  imports = [
    ../common.nix
  ];

  # GUI Applications for personal machine
  programs.firefox.enable = true;
  programs.vscode.enable = true;

  home.packages = with pkgs; [
    vesktop
    spotify
    slack
  ];
}
