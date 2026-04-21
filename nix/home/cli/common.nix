{ pkgs, ... }:

{
  home.packages = [
    pkgs.fzf
    pkgs.tree
    pkgs.ripgrep
    pkgs.glow
  ];

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };
}
