{ config, pkgs, dotfilesPath, ... }:

{
  programs.tmux = {
    enable = true;
    clock24 = true;
    extraConfig = builtins.readFile "${dotfilesPath}/tmux/tmux.conf";
  };
}
