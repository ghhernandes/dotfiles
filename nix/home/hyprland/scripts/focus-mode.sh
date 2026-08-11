#!/usr/bin/env bash
# Focus mode = Do Not Disturb: pause/resume dunst notifications.
#   focus-mode toggle   toggle on/off (default)
#   focus-mode on|off   force a state
#   focus-mode status   print a waybar indicator (icon when active, else empty)

paused() { [ "$(dunstctl is-paused)" = "true" ]; }

enable() {
    # Notify first, then pause — otherwise the confirmation is silenced too.
    notify-send "Focus mode on" "Notifications silenced"
    sleep 0.3
    dunstctl set-paused true
}

disable() {
    dunstctl set-paused false
    notify-send "Focus mode off" "Notifications resumed"
}

case "${1:-toggle}" in
    toggle) if paused; then disable; else enable; fi ;;
    on) paused || enable ;;
    off) paused && disable ;;
    status) if paused; then echo "󰂛"; else echo ""; fi ;;
esac
