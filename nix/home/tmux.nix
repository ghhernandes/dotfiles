{ config, pkgs, dotfilesPath, ... }:

{
  programs.tmux = {
    enable = true;
    clock24 = true;
    extraConfig = builtins.readFile "${dotfilesPath}/tmux/tmux.conf";
  };

  home.file.".local/bin/gh-tmux-session" = {
    source = "${dotfilesPath}/local-bin/gh-tmux-session";
    executable = true;
  };
}
