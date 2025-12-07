{ config, pkgs, ... }:

{
  imports = [
    ../common.nix
    ../modules/clojure.nix
    ../modules/cli.nix
  ];

  home.packages = with pkgs; [
    firefox
    vscode
    vesktop
    spotify
    slack
  ];
}
