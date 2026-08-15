_:

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
          "custom/caffeine"
          "custom/focus"
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
          on-click = "kitty --class btop-float btop";
        };

        memory = {
          interval = 5;
          format = "󰍛";
          tooltip-format = "RAM {percentage}% ({used:0.1f}G / {total:0.1f}G)";
          on-click = "kitty --class btop-float btop";
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
          on-click = "kitty --class impala-float impala";
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
          on-click = "pavucontrol";
          on-click-right = "pamixer -t";
        };

        bluetooth = {
          format = "";
          format-off = "󰂲";
          format-disabled = "󰂲";
          format-connected = "󰂱";
          format-no-controller = "";
          tooltip-format = "Devices connected: {num_connections}";
          on-click = "kitty --class bluetui-float bluetui";
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

        "custom/focus" = {
          exec = "focus-mode status";
          interval = 2;
          format = "{}";
          tooltip-format = "Focus mode (Do Not Disturb) active";
          on-click = "focus-mode toggle";
        };

        "custom/caffeine" = {
          exec = "caffeine status";
          interval = 2;
          format = "{}";
          tooltip-format = "Caffeine: lid close and idle sleep disabled\nRight-click to set a duration";
          on-click = "caffeine toggle";
          on-click-right = "caffeine menu";
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
      #bluetooth,
      #custom-focus,
      #custom-caffeine {
        margin: 0 7px;
      }

      #custom-focus {
        color: #f9e2af;
      }

      #custom-caffeine {
        color: #a6e3a1;
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
