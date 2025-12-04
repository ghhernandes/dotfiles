{ config, pkgs, ...}:

{
  programs.tmux = {
    enable = true;
    clock24 = true;
  };

  xdg.configFile."tmux/tmux.conf".source = ../../../tmux/tmux.conf;

  home.file.".local/bin/tmux-session" = {
    source = ../../../scripts/tmux-session;
    executable = true;
  };
}
