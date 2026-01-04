{ pkgs, ... }:

{
  home.packages = [
    pkgs.yubikey-manager
    pkgs.yubioath-flutter
  ];
}
