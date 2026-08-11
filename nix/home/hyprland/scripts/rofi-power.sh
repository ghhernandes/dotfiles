#!/usr/bin/env bash
# Rofi power menu: power off / reboot / suspend / hibernate (lock first) / logout

main() {
    local options="Power Off\nReboot\nSuspend\nHibernate\nLogout"
    local chosen
    chosen=$(echo -e "$options" | rofi -dmenu -p "Power" -theme custom)

    case "$chosen" in
        "Power Off") systemctl poweroff ;;
        "Reboot") systemctl reboot ;;
        "Suspend")
            hyprlock &
            sleep 0.5
            systemctl suspend
            ;;
        "Hibernate")
            hyprlock &
            sleep 0.5
            systemctl hibernate
            ;;
        "Logout") loginctl terminate-user "$USER" ;;
    esac
}

main
