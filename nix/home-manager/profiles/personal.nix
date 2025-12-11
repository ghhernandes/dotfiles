{ config, pkgs, ... }:

{
  imports = [
    ../common.nix
    ../modules/clojure.nix
    ../modules/cli.nix
  ];

  home.packages = with pkgs; [
    firefox
    gimp
    vscode
    vesktop
    spotify
    slack
    yubikey-manager
    yubioath-flutter
  ];
}
