{ pkgs, ... }:

{
  home.packages = [
    pkgs.vesktop
    pkgs.slack
  ];
}
