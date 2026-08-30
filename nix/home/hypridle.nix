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
          # ASUS keyboard backlight (asus::kbd_backlight); no-op elsewhere.
          # Fixed values rather than brightnessctl -s/-r (save/restore): this
          # listener's on-resume always snaps back to 1, the same default the
          # boot service (kbd-backlight-default) restores, so it stays correct
          # even if another actor also touched the LED while idle.
          timeout = 60; # 1 min: keyboard backlight off
          on-timeout = "brightnessctl -d asus::kbd_backlight set 0";
          on-resume = "brightnessctl -d asus::kbd_backlight set 1";
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
