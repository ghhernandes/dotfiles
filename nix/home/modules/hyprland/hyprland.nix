{ config, pkgs, ... }:

{
  home.packages = with pkgs; [
    kitty          # Terminal emulator
    rofi           # Application launcher
    waybar         # Status bar
    dunst          # Notification daemon
    libnotify      # Notification utilities (notify-send)
    swww           # Wallpaper daemon
    pamixer        # Audio control
    playerctl      # Media player control
    pavucontrol    # GUI audio control
    blueman        # Bluetooth manager GUI
    hyprlock       # Screen locker
  ];

  wayland.windowManager.hyprland = {
    enable = true;
    systemd.enable = false;  # Disable to avoid conflicts with UWSM

    settings = {
      monitor = "DP-1,2560x1440@165,auto,1";

      "$mod" = "SUPER";

      "$terminal" = "kitty";
      "$menu" = "rofi -show drun";

      exec-once = [
        "waybar"
        "dunst"
      ];

      bind = [
        # Applications
        "$mod, Return, exec, $terminal"
        "$mod, Q, killactive"
        "$mod, M, exec, $HOME/.local/bin/rofi-power"
        "$mod, E, exec, nautilus"
        "$mod, V, togglefloating"
        "$mod, F, fullscreen"
        "$mod, D, exec, $menu"
        "$mod, L, exec, hyprlock"
        "$mod, B, exec, $HOME/.local/bin/rofi-bluetooth"

        # Move focus with mod + arrow keys
        "$mod, left, movefocus, l"
        "$mod, right, movefocus, r"
        "$mod, up, movefocus, u"
        "$mod, down, movefocus, d"

        # Switch workspaces with mod + [0-9]
        "$mod, 1, workspace, 1"
        "$mod, 2, workspace, 2"
        "$mod, 3, workspace, 3"
        "$mod, 4, workspace, 4"
        "$mod, 5, workspace, 5"
        "$mod, 6, workspace, 6"
        "$mod, 7, workspace, 7"
        "$mod, 8, workspace, 8"
        "$mod, 9, workspace, 9"
        "$mod, 0, workspace, 10"

        # Move active window to a workspace with mod + SHIFT + [0-9]
        "$mod SHIFT, 1, movetoworkspace, 1"
        "$mod SHIFT, 2, movetoworkspace, 2"
        "$mod SHIFT, 3, movetoworkspace, 3"
        "$mod SHIFT, 4, movetoworkspace, 4"
        "$mod SHIFT, 5, movetoworkspace, 5"
        "$mod SHIFT, 6, movetoworkspace, 6"
        "$mod SHIFT, 7, movetoworkspace, 7"
        "$mod SHIFT, 8, movetoworkspace, 8"
        "$mod SHIFT, 9, movetoworkspace, 9"
        "$mod SHIFT, 0, movetoworkspace, 10"
      ];

      # Media and audio control keybindings
      bindl = [
        # Audio controls
        ", XF86AudioRaiseVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+"
        ", XF86AudioLowerVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"
        ", XF86AudioMute, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"

        # Media controls
        ", XF86AudioPlay, exec, playerctl play-pause"
        ", XF86AudioPause, exec, playerctl play-pause"
        ", XF86AudioNext, exec, playerctl next"
        ", XF86AudioPrev, exec, playerctl previous"
      ];

      input = {
        kb_layout = "us";
        kb_variant = "";
        kb_model = "";
        kb_options = "";
        kb_rules = "";

        follow_mouse = 1;
        sensitivity = 0;
      };

      general = {
        gaps_in = 2;
        gaps_out = 5;
        border_size = 1;
        "col.active_border" = "rgba(458588ff)";  # Simple blue
        "col.inactive_border" = "rgba(282828aa)";
        layout = "dwindle";
      };

      decoration = {
        rounding = 0;  # No rounded corners
        blur = {
          enabled = false;  # No blur
        };
        shadow = {
          enabled = true;  # No shadows
        };
      };

      animations = {
        enabled = false;  # Disable animations for snappy feel
      };
    };
  };
}
