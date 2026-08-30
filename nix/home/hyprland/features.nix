{ pkgs, ... }:

# Feature declarations for desktop.features (schema: ./feature.nix). Each
# entry replaces what used to be a script registration in scripts.nix, a
# bind in hyprland.nix, and a waybar module + CSS rule in waybar.nix.
{
  desktop.features.focus-mode = {
    runtimeInputs = with pkgs; [
      dunst
      libnotify
      coreutils
    ];
    subcommands = [
      "toggle"
      "on"
      "off"
      "status"
    ];
    binds = [
      {
        key = "N";
        run = "toggle";
      }
    ];
    widget = {
      order = 20;
      color = "#f9e2af";
      onClick = "toggle";
      tooltip = "Focus mode (Do Not Disturb) active";
      id = "focus"; # matches the pre-existing waybar module id / CSS class
    };
  };

  desktop.features.caffeine = {
    runtimeInputs = with pkgs; [
      systemd
      procps
      libnotify
      coreutils
      gnugrep
      rofi
    ];
    subcommands = [
      "toggle"
      "menu"
      "on"
      "off"
      "status"
    ];
    binds = [
      {
        key = "C";
        run = "toggle";
      }
      {
        mods = "$mod SHIFT";
        key = "C";
        run = "menu";
      }
    ];
    widget = {
      order = 10;
      color = "#a6e3a1";
      onClick = "toggle";
      onClickRight = "menu";
      tooltip = "Caffeine: lid close and idle sleep disabled\nRight-click to set a duration";
    };
  };
}
