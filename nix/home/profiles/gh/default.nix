{ config, pkgs, ... }:

{
  imports = [
    ../../common.nix
    ../../clojure.nix
    ../../cli.nix
    ../../hyprland
    ../../kitty.nix
    ../../rofi
  ];

  home.packages = with pkgs; [
    firefox
    google-chrome
    gimp
    vscode
    vesktop
    spotify
    slack
    yubikey-manager
    yubioath-flutter
  ];
}
