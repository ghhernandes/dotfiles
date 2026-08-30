{ config, ... }:

{
  programs.waybar = {
    enable = true;
    systemd.enable = true; # start with graphical-session.target, not exec-once
    settings = {
      mainBar = {
        layer = "top";
        position = "top";
        height = 26;
        spacing = 0;
        reload_style_on_change = true;

        modules-left = [
          "hyprland/workspaces"
        ];
        modules-center = [
          "clock"
        ];
        modules-right = [
          "group/tray-expander"
          "bluetooth"
          "network"
          "pulseaudio"
          "cpu"
          "memory"
          "battery"
        ];

        "hyprland/workspaces" = {
          on-click = "activate";
          format = "{icon}";
          format-icons = {
            default = "";
            active = "󱓻";
            "1" = "1";
            "2" = "2";
            "3" = "3";
            "4" = "4";
            "5" = "5";
            "6" = "6";
            "7" = "7";
            "8" = "8";
            "9" = "9";
            "10" = "0";
          };
          persistent-workspaces = {
            "1" = [ ];
            "2" = [ ];
            "3" = [ ];
            "4" = [ ];
            "5" = [ ];
          };
        };

        clock = {
          format = "{:L%a %H:%M}";
          format-alt = "{:L%d %b W%V %Y}";
          tooltip = false;
        };

        cpu = {
          interval = 5;
          format = "󰻠";
          tooltip-format = "CPU {usage}%";
          on-click = config.desktop.floats.btop.launch;
        };

        memory = {
          interval = 5;
          format = "󰍛";
          tooltip-format = "RAM {percentage}% ({used:0.1f}G / {total:0.1f}G)";
          on-click = config.desktop.floats.btop.launch;
        };

        battery = {
          format = "{capacity}% {icon}";
          format-charging = "{capacity}% {icon}";
          format-full = "{capacity}% 󰂅";
          format-icons = {
            charging = [
              "󰢜"
              "󰂆"
              "󰂇"
              "󰂈"
              "󰢝"
              "󰂉"
              "󰢞"
              "󰂊"
              "󰂋"
              "󰂅"
            ];
            default = [
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
          tooltip-format-discharging = "{power:>1.0f}W↓ {capacity}%";
          tooltip-format-charging = "{power:>1.0f}W↑ {capacity}%";
          interval = 5;
          states = {
            warning = 20;
            critical = 10;
          };
        };

        network = {
          format = "{icon}";
          format-icons = [
            "󰤯"
            "󰤟"
            "󰤢"
            "󰤥"
            "󰤨"
          ];
          format-wifi = "{icon}";
          format-ethernet = "󰀂";
          format-disconnected = "󰤮";
          tooltip-format-wifi = "{essid} ({signalStrength}%)";
          tooltip-format-ethernet = "Connected";
          tooltip-format-disconnected = "Disconnected";
          interval = 5;
          on-click = config.desktop.floats.impala.launch;
        };

        pulseaudio = {
          format = "{icon}";
          format-muted = "";
          format-icons = {
            headphone = "";
            headset = "";
            default = [
              ""
              ""
              ""
            ];
          };
          scroll-step = 5;
          tooltip-format = "Playing at {volume}%";
          on-click = config.desktop.floats.pavucontrol.launch;
          on-click-right = "pamixer -t";
        };

        bluetooth = {
          format = "";
          format-off = "󰂲";
          format-disabled = "󰂲";
          format-connected = "󰂱";
          format-no-controller = "";
          tooltip-format = "Devices connected: {num_connections}";
          on-click = config.desktop.floats.bluetui.launch;
        };

        "group/tray-expander" = {
          orientation = "inherit";
          drawer = {
            transition-duration = 600;
            children-class = "tray-group-item";
          };
          modules = [
            "custom/expand-icon"
            "tray"
          ];
        };

        "custom/expand-icon" = {
          format = "";
          tooltip = false;
        };

        tray = {
          icon-size = 13;
          spacing = 12;
        };

      };
    };
    style = ''
      * {
        font-family: "JetBrainsMono Nerd Font", "JetBrainsMono Nerd Font Propo", "DejaVu Sans", sans-serif;
        font-size: 16px;
        font-weight: 500;
        border: none;
        border-radius: 0;
        min-height: 0;
      }

      window#waybar {
        background-color: #1e1e1e;
        color: #ffffff;
      }

      .modules-left {
        margin-left: 8px;
      }

      .modules-right {
        margin-right: 8px;
      }

      #workspaces button {
        all: initial;
        padding: 0 6px;
        margin: 0 2px;
        min-width: 9px;
        color: #888888;
      }

      #workspaces button.active {
        color: #33ccff;
      }

      #workspaces button.empty {
        opacity: 0.5;
      }

      #workspaces button:hover {
        color: #ffffff;
      }

      #clock,
      #cpu,
      #memory,
      #battery,
      #network,
      #pulseaudio,
      #bluetooth {
        margin: 0 7px;
      }

      #tray {
        margin-right: 16px;
      }

      #custom-expand-icon {
        margin-right: 12px;
      }

      #battery.warning {
        color: #f9e2af;
      }

      #battery.critical {
        color: #f38ba8;
      }

      tooltip {
        padding: 2px;
      }
    '';
  };
}
