{ config, pkgs, ... }:

{
  # Install essential Hyprland applications
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
  ];

  # Configure Hyprland via home-manager
  wayland.windowManager.hyprland = {
    enable = true;
    systemd.enable = false;  # Disable to avoid conflicts with UWSM

    settings = {
      # Set modifier key (Super/Windows key)
      "$mod" = "SUPER";

      # Define default terminal and launcher
      "$terminal" = "kitty";
      "$menu" = "rofi -show drun";

      # Autostart applications
      exec-once = [
        "waybar"
        "dunst"
        "hyprctl setcursor Adwaita 24"
      ];

      # Essential keybindings
      bind = [
        # Applications
        "$mod, Return, exec, $terminal"
        "$mod, Q, killactive"
        "$mod, M, exit"
        "$mod, E, exec, nautilus"
        "$mod, V, togglefloating"
        "$mod, D, exec, $menu"
        "$mod, P, pseudo"
        "$mod, J, togglesplit"

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

        # Scroll through existing workspaces with mod + scroll
        "$mod, mouse_down, workspace, e+1"
        "$mod, mouse_up, workspace, e-1"
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

      # Mouse bindings
      bindm = [
        "$mod, mouse:272, movewindow"
        "$mod, mouse:273, resizewindow"
      ];

      # Input configuration (keyboard, mouse, touchpad)
      input = {
        kb_layout = "us";
        kb_variant = "";
        kb_model = "";
        kb_options = "";
        kb_rules = "";

        follow_mouse = 1;
        sensitivity = 0;
      };

      # Minimal aesthetics (i3/Sway-like)
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
    };
  };

  # Configure kitty terminal
  programs.kitty = {
    enable = true;
    theme = "Tokyo Night";
    settings = {
      font_size = 12;
      background_opacity = "0.95";
      confirm_os_window_close = 0;
    };
  };

  # Configure Waybar
  programs.waybar = {
    enable = true;
    settings = {
      mainBar = {
        layer = "top";
        position = "top";
        height = 30;
        modules-left = [ "hyprland/workspaces" "hyprland/window" ];
        modules-center = [ "clock" ];
        modules-right = [ "pulseaudio" "network" "bluetooth" "cpu" "memory" "battery" "tray" ];

        "hyprland/workspaces" = {
          format = "{id}";
          on-click = "activate";
        };

        "hyprland/window" = {
          max-length = 50;
        };

        clock = {
          format = "{:%H:%M}";
          format-alt = "{:%Y-%m-%d}";
        };

        cpu = {
          format = "CPU {usage}%";
        };

        memory = {
          format = "MEM {}%";
        };

        battery = {
          format = "BAT {capacity}%";
          format-charging = "CHG {capacity}%";
          format-plugged = "PLUG {capacity}%";
        };

        network = {
          format-wifi = "WIFI {signalStrength}%";
          format-ethernet = "ETH";
          format-disconnected = "NO NET";
        };

        pulseaudio = {
          format = "VOL {volume}%";
          format-muted = "MUTE";
          on-click = "pavucontrol";
        };

        bluetooth = {
          format = "BT {status}";
          format-disabled = "BT OFF";
          format-connected = "BT {num_connections}";
          on-click = "blueman-manager";
        };
      };
    };
    style = ''
      * {
        font-family: monospace;
        font-size: 13px;
        border: none;
        border-radius: 0;
      }

      window#waybar {
        background-color: #1e1e1e;
        color: #ffffff;
      }

      #workspaces button {
        padding: 0 8px;
        background-color: transparent;
        color: #888888;
      }

      #workspaces button.active {
        color: #ffffff;
        background-color: #383838;
      }

      #workspaces button:hover {
        background-color: #2a2a2a;
      }

      #window,
      #clock,
      #cpu,
      #memory,
      #battery,
      #network,
      #pulseaudio,
      #bluetooth,
      #tray {
        padding: 0 10px;
      }
    '';
  };

  # Configure Dunst notification daemon
  services.dunst = {
    enable = true;
    settings = {
      global = {
        # Display settings
        monitor = 0;
        follow = "mouse";

        # Geometry
        width = "(200, 400)";
        height = 300;
        origin = "top-center";
        offset = "0x40";

        # Layout
        padding = 12;
        horizontal_padding = 12;
        frame_width = 1;
        gap_size = 4;
        separator_height = 1;
        separator_color = "frame";

        # Typography
        font = "monospace 11";
        line_height = 0;
        markup = "full";
        format = "<b>%s</b>\\n%b";
        alignment = "left";
        vertical_alignment = "center";
        show_age_threshold = 60;
        word_wrap = true;
        ellipsize = "middle";
        ignore_newline = false;
        stack_duplicates = true;
        hide_duplicate_count = false;
        show_indicators = true;

        # Icons
        icon_position = "left";
        min_icon_size = 0;
        max_icon_size = 48;

        # Interaction
        sticky_history = true;
        history_length = 20;
        browser = "xdg-open";
        always_run_script = true;

        # Appearance
        corner_radius = 0;
        transparency = 0;

        # Mouse actions
        mouse_left_click = "close_current";
        mouse_middle_click = "do_action, close_current";
        mouse_right_click = "close_all";
      };

      # Low urgency notifications (info)
      urgency_low = {
        background = "#1e1e1e";
        foreground = "#888888";
        frame_color = "#383838";
        timeout = 5;
      };

      # Normal urgency notifications
      urgency_normal = {
        background = "#1e1e1e";
        foreground = "#ffffff";
        frame_color = "#ffffff";
        timeout = 8;
      };

      # Critical urgency notifications
      urgency_critical = {
        background = "#1e1e1e";
        foreground = "#ffffff";
        frame_color = "#ff5555";
        timeout = 0;
      };
    };
  };

  # Configure Rofi application launcher
  programs.rofi = {
    enable = true;
    package = pkgs.rofi;
    theme = "custom";
    extraConfig = {
      modi = "drun,run,window";
      show-icons = true;
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

  # Create custom minimal rofi theme
  home.file.".config/rofi/custom.rasi".text = ''
    * {
      bg-col:  #1e1e1e;
      bg-col-light: #383838;
      border-col: #458588;
      selected-col: #383838;
      fg-col: #ffffff;
      fg-col2: #888888;
      width: 600;
    }

    element-text, element-icon, mode-switcher {
      background-color: inherit;
      text-color: inherit;
    }

    window {
      height: 400px;
      border: 1px;
      border-color: @border-col;
      border-radius: 0px;
      background-color: @bg-col;
    }

    mainbox {
      background-color: @bg-col;
    }

    inputbar {
      children: [prompt,entry];
      background-color: @bg-col;
      border-radius: 0px;
      padding: 8px;
    }

    prompt {
      background-color: @bg-col-light;
      padding: 8px;
      text-color: @fg-col;
      margin: 0px 4px 0px 0px;
    }

    textbox-prompt-colon {
      expand: false;
      str: ":";
    }

    entry {
      padding: 8px;
      background-color: @bg-col;
      text-color: @fg-col;
    }

    listview {
      border: 0px 0px 0px;
      padding: 6px 0px 0px;
      columns: 1;
      lines: 8;
      background-color: @bg-col;
    }

    element {
      padding: 8px;
      background-color: @bg-col;
      text-color: @fg-col2;
    }

    element-icon {
      size: 20px;
    }

    element selected {
      background-color: @selected-col;
      text-color: @fg-col;
    }

    mode-switcher {
      spacing: 0;
    }

    button {
      padding: 8px;
      background-color: @bg-col-light;
      text-color: @fg-col2;
      vertical-align: 0.5;
      horizontal-align: 0.5;
    }

    button selected {
      background-color: @bg-col;
      text-color: @fg-col;
    }

    message {
      background-color: @bg-col-light;
      margin: 2px;
      padding: 2px;
      border-radius: 0px;
    }

    textbox {
      padding: 8px;
      background-color: @bg-col;
      text-color: @fg-col;
    }
  '';
}
