{ config, pkgs, ... }:

{
  programs.waybar = {
    enable = true;
    settings = {
      mainBar = {
        layer = "top";
        position = "top";
        height = 30;
        modules-left = [ "hyprland/workspaces" "hyprland/window" ];
        modules-center = [ "custom/gh-pomodoro" "clock" ];
        modules-right = [ "pulseaudio" "network" "bluetooth" "cpu" "memory" "battery" "clock#date" ];

        "hyprland/workspaces" = {
          format = "{id}";
          on-click = "activate";
        };

        "hyprland/window" = {
          max-length = 50;
        };

        "clock#date" = {
          format = "{:%b %d}";
        };

        clock = {
          format = "{:%I:%M %p}";
        };

        cpu = {
          format = "CPU {usage}%";
        };

        temperature = {
          format = "TEMP {temperatureC}°C";
          critical-threshold = 80;
          format-critical = "TEMP {temperatureC}°C";
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

        "custom/gh-pomodoro" = {
          exec = "gh-pomodoro status";
          interval = 1;
          format = "{}";
          on-click = "gh-pomodoro stop";
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
      #tray,
      #custom-gh-pomodoro {
        padding: 0 10px;
      }
    '';
  };
}
