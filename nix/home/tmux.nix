{ config, pkgs, dotfilesPath, ... }:

{
  programs.tmux = {
    enable = true;
    clock24 = true;
    extraConfig = builtins.readFile "${dotfilesPath}/tmux/tmux.conf";
  };

  home.file.".local/bin/tmux-session" = {
    source = "${dotfilesPath}/scripts/tmux-session";
    executable = true;
  };
}
