{ pkgs, ... }:

{
  # Icon theme rofi resolves via `icon-theme` below; without a theme package
  # on the profile, `show-icons` renders nothing.
  home.packages = [ pkgs.papirus-icon-theme ];

  programs.rofi = {
    enable = true;
    package = pkgs.rofi;
    theme = "custom";
    extraConfig = {
      modi = "drun,run,window";
      show-icons = true;
      icon-theme = "Papirus-Dark";
      matching = "fuzzy";
      terminal = "kitty";
      drun-display-format = "{name}";
      location = 0;
      disable-history = false;
      hide-scrollbar = true;
      display-drun = "Apps";
      display-run = "Run";
      display-window = "Windows";
      sidebar-mode = false;
    };
  };
}
