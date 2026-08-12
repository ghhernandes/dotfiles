_:

# Idle management: lock, then blank the screen, then suspend. Laptop-scoped
# (imported per-host) — deliberately not applied to hosts that must stay awake
# for remote access (e.g. ghstation runs Sunshine).
{
  services.hypridle = {
    enable = true;
    settings = {
      general = {
        lock_cmd = "pidof hyprlock || hyprlock";
        before_sleep_cmd = "loginctl lock-session";
        after_sleep_cmd = "hyprctl dispatch dpms on";
      };
      listener = [
        {
          timeout = 300; # 5 min: lock
          on-timeout = "loginctl lock-session";
        }
        {
          timeout = 360; # 6 min: screen off
          on-timeout = "hyprctl dispatch dpms off";
          on-resume = "hyprctl dispatch dpms on";
        }
        {
          timeout = 1800; # 30 min: suspend
          on-timeout = "systemctl suspend";
        }
      ];
    };
  };
}
