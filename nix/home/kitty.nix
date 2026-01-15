{ config, pkgs, ... }:

{
  programs.kitty = {
    enable = true;
    themeFile = "tokyo_night_night";
    settings = {
      font_family = "JetBrainsMono Nerd Font";
      font_size = 13;
      background_opacity = "0.70";
      confirm_os_window_close = 0;
    };
  };
}
