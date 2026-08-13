#!/usr/bin/env bash
# Rofi power menu: power off / reboot / suspend / hibernate (lock first) / logout

main() {
    local options="Power Off\nReboot\nSuspend\nHibernate\nLogout"
    local chosen
    chosen=$(echo -e "$options" | rofi -dmenu -p "Power" -theme custom)

    case "$chosen" in
        "Power Off") systemctl poweroff ;;
        "Reboot") systemctl reboot ;;
        # Locking is left to hypridle, which holds a *delay* inhibitor on sleep
        # and runs `loginctl lock-session` from it, so the lock is guaranteed to
        # be up before the machine goes down. -i only disables the *block*
        # inhibitor check, letting an explicit choice here override caffeine
        # while the automatic paths (lid, idle) keep respecting it.
        "Suspend") systemctl suspend -i ;;
        "Hibernate") systemctl hibernate -i ;;
        "Logout") loginctl terminate-user "$USER" ;;
    esac
}

main
