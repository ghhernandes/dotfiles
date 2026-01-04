{ pkgs, ... }:

{
  home.packages = [
    pkgs.firefox
    pkgs.google-chrome
  ];
}
