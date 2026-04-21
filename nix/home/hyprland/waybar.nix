_:

{
  programs.waybar = {
    enable = true;
    settings = {
      mainBar = {
        layer = "top";
        position = "top";
        height = 30;
        modules-left = [
          "hyprland/workspaces"
          "hyprland/window"
        ];
        modules-center = [
          "custom/gh-pomodoro"
          "clock"
        ];
        modules-right = [
          "pulseaudio"
          "network"
          "bluetooth"
          "cpu"
          "memory"
          "battery"
        ];

        "hyprland/workspaces" = {
          format = "{id}";
          on-click = "activate";
        };

        "hyprland/window" = {
          max-length = 50;
        };

        clock = {
          format = "{:%b %d %I:%M %p}";
        };

        cpu = {
          format = "󰻠 {usage}%";
        };

        temperature = {
          format = "󰔏 {temperatureC}°C";
          critical-threshold = 80;
          format-critical = "󰸁 {temperatureC}°C";
        };

        memory = {
          format = "󰍛 {}%";
        };

        battery = {
          format = "{icon} {capacity}%";
          format-charging = "󰂄 {capacity}%";
          format-plugged = "󰚥 {capacity}%";
          format-icons = [
            "󰂎"
            "󰁺"
            "󰁻"
            "󰁼"
            "󰁽"
            "󰁾"
            "󰁿"
            "󰂀"
            "󰂁"
            "󰂂"
            "󰁹"
          ];
        };

        network = {
          format-wifi = "󰖩 {signalStrength}%";
          format-ethernet = "󰈀 ETH";
          format-disconnected = "󰖪 NO NET";
          on-click = "kitty --class impala-float impala";
        };

        pulseaudio = {
          format = "{icon} {volume}%";
          format-muted = "󰖁 MUTE";
          format-icons = {
            default = [
              "󰕿"
              "󰖀"
              "󰕾"
            ];
          };
          on-click = "pavucontrol";
        };

        bluetooth = {
          format = "󰂯 {status}";
          format-disabled = "󰂲 OFF";
          format-connected = "󰂱 {num_connections}";
          on-click = "kitty --class bluetui-float bluetui";
        };

        "custom/gh-pomodoro" = {
          exec = "gh-pomodoro-status";
          interval = 1;
          format = "{}";
          on-click = "gh-pomodoro-stop";
        };
      };
    };
    style = ''
      * {
        font-family: "JetBrainsMono Nerd Font Propo", "DejaVu Sans", sans-serif;
        font-size: 14px;
        font-weight: 500;
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
      #tray,
      #custom-gh-pomodoro {
        padding: 0 10px;
      }
    '';
  };
}
