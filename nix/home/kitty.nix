{ config, pkgs, ... }:

{
  programs.kitty = {
    enable = true;
    themeFile = "tokyo_night_night";
    settings = {
      font_size = 12;
      background_opacity = "0.95";
      confirm_os_window_close = 0;
    };
  };
}
