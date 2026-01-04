{ config, pkgs, ... }:

{
  imports = [
    ../../common.nix
    ../../modules/clojure.nix
    ../../modules/cli.nix
    ../../modules/hyprland
    ../../modules/kitty.nix
    ../../modules/rofi
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
