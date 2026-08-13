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
      # Locking and screen-off are unconditional. The sleep step needs no guard
      # of its own: `systemctl` already refuses a sleep while something holds a
      # block inhibitor on it, which is exactly how caffeine suppresses this.
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
          timeout = 1800; # 30 min: sleep, unless inhibited
          on-timeout = "systemctl suspend-then-hibernate";
        }
      ];
    };
  };
}
