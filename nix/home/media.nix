{ pkgs, ... }:

{
  home.packages = with pkgs; [
    spotify
    gimp
  ];
}
