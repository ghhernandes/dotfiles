{ pkgs, ... }:

{
  home.packages = [
    pkgs.fzf
    pkgs.tree
    pkgs.ripgrep
    pkgs.glow
  ];
}
