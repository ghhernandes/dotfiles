{ config, pkgs, ... }:

{
  home.packages = [
    pkgs.kitty          # Terminal emulator
    pkgs.rofi           # Application launcher
    pkgs.waybar         # Status bar
    pkgs.dunst          # Notification daemon
    pkgs.libnotify      # Notification utilities (notify-send)
    pkgs.swww           # Wallpaper daemon
    pkgs.pamixer        # Audio control
    pkgs.playerctl      # Media player control
    pkgs.pavucontrol    # GUI audio control
    pkgs.blueman        # Bluetooth manager GUI
    pkgs.hyprlock       # Screen locker
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

      # Window rules for fixed workspaces
      windowrulev2 = [
        # Workspace 1: kitty
        "workspace 1, class:^(kitty)$"

        # Workspace 2: Firefox and Chrome
        "workspace 2, class:^(firefox)$"
        "workspace 2, class:^(Google-chrome)$"
        "workspace 2, class:^(google-chrome)$"

        # Workspace 3: Editors
        "workspace 3, class:^(Emacs)$"
        "workspace 3, class:^(emacs)$"

        # Workspace 4: File managers
        "workspace 4, class:^(org.gnome.Nautilus)$"

        # Workspace 6: Spotify, Music
        "workspace 6, class:^(Spotify)$"
        "workspace 6, class:^(spotify)$"

        # Workspace 7: Obsidian
        "workspace 7, class:^(obsidian)$"
        "workspace 7, class:^(Obsidian)$"

        # Workspace 9: Messaging
        "workspace 9, class:^(vesktop)$"
        "workspace 9, class:^(Vesktop)$"
        "workspace 9, class:^(discord)$"
        "workspace 9, class:^(Discord)$"
        "workspace 9, class:^(Slack)$"
        "workspace 9, class:^(slack)$"
        "workspace 9, class:^(signal)$"
        "workspace 9, class:^(Signal)$"

        # 1Password: Floating and centered
        "float, class:^(1password)$"
        "center, class:^(1password)$"
        "size 800 600, class:^(1password)$"

        # Volume control: Floating and centered
        "float, class:^(org.pulseaudio.pavucontrol)$"
        "center, class:^(org.pulseaudio.pavucontrol)$"
        "size 800 600, class:^(org.pulseaudio.pavucontrol)$"

        # Gaming: Auto fullscreen
        "fullscreen, class:^(steam_app_).*"
        "fullscreen, class:^(Wine)$"
        "fullscreen, class:^(steam_proton)$"
        "fullscreen, title:^(.* - Wine desktop)$"
      ];

      bind = [
        # Applications
        "$mod, Return, exec, $terminal"
        "$mod, Q, killactive"
        "$mod, E, exec, nautilus"
        "$mod, V, togglefloating"
        "$mod, F, fullscreen"

        "$mod, SPACE, exec, $menu"
        "$mod SHIFT, E, exec, emacs"
        "$mod SHIFT, O, exec, obsidian"
        "$mod SHIFT, M, exec, spotify"
        "$mod SHIFT, G, exec, signal"
        "$mod SHIFT, slash, exec, 1password"

        "$mod, L, exec, hyprlock"
        "$mod, M, exec, $HOME/.local/bin/gh-rofi-power"
        "$mod, B, exec, $HOME/.local/bin/gh-rofi-bluetooth"

        # Screenshots
        ", Print, exec, $HOME/.local/bin/gh-screenshot full"
        "SHIFT, Print, exec, $HOME/.local/bin/gh-screenshot region"
        "CTRL, Print, exec, $HOME/.local/bin/gh-screenshot clipboard"
        "$mod, Print, exec, $HOME/.local/bin/gh-screenshot window"

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
          enabled = false;  # No shadows
        };
      };

      animations = {
        enabled = false;  # Disable animations for snappy feel
      };

      misc = {
        vfr = true;  # Variable frame rate to save battery
      };
    };
  };
}
