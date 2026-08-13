#!/usr/bin/env bash
# Caffeine: hold a systemd inhibitor so the machine won't sleep on its own.
# For long unattended jobs (agent runs, builds) that must survive a closed lid.
#   caffeine toggle        toggle indefinite on/off (default)
#   caffeine menu          rofi picker for a duration (or to turn it off)
#   caffeine on [seconds]  force on; no argument means indefinite
#   caffeine off           force off
#   caffeine status        waybar indicator (icon + remaining time, else empty)

# The inhibitor's reason, and the fingerprint used to confirm a recorded PID is
# really our process and not an unrelated one that reused the number.
marker="caffeine-inhibit"
runtime="${XDG_RUNTIME_DIR:-/tmp}"
pid_file="$runtime/caffeine.pid"
expiry_file="$runtime/caffeine.expiry"

# Tracked by PID rather than a cmdline pattern: pattern matching would also
# hit unrelated processes that merely mention the marker (a shell running
# `pgrep caffeine-inhibit`, say) and kill them on the next toggle.
active() {
    local pid
    [ -r "$pid_file" ] || return 1
    pid=$(cat "$pid_file") || return 1
    [ -n "$pid" ] || return 1
    kill -0 "$pid" 2>/dev/null || return 1
    grep -qa "$marker" "/proc/$pid/cmdline" 2>/dev/null
}

stop() {
    local pid
    if active; then kill "$(cat "$pid_file")" 2>/dev/null || true; fi
    # Also reap orphans whose pid file was lost (killed shell, crashed session);
    # otherwise a stale lock keeps the machine awake with no way to see why.
    # -x matches the process *name*, so only real inhibitors are ever candidates
    # and the cmdline check confirms the marker before anything is signalled.
    for pid in $(pgrep -x systemd-inhibit 2>/dev/null || true); do
        if grep -qa "$marker" "/proc/$pid/cmdline" 2>/dev/null; then
            kill "$pid" 2>/dev/null || true
        fi
    done
    rm -f "$pid_file" "$expiry_file"
}

# Prints the time left on a timed session; fails when running indefinitely.
remaining() {
    local now end left
    [ -f "$expiry_file" ] || return 1
    now=$(date +%s)
    end=$(cat "$expiry_file")
    left=$((end - now))
    [ "$left" -gt 0 ] || return 1
    if [ "$left" -ge 3600 ]; then
        printf '%dh%02dm' $((left / 3600)) $(((left % 3600) / 60))
    else
        printf '%dm' $(((left + 59) / 60))
    fi
}

# $1: seconds to stay awake; omitted or 0 means until switched off.
enable() {
    local secs="${1:-0}" label duration
    # Never stack inhibitors — a second one would outlive the first's timer.
    stop

    if [ "$secs" -gt 0 ]; then
        date -d "+$secs seconds" +%s >"$expiry_file"
        duration="$secs"
    else
        duration="infinity"
    fi

    # Only `sleep` is inhibited, which power-ctl reads as its veto. Locking and
    # screen-off are deliberately left alone: they don't stop a running job, and
    # suppressing them would leave the machine unlocked exactly while it's
    # unattended. The rofi power menu passes -i, so deliberately choosing
    # suspend still overrides this.
    #
    # The lock lives exactly as long as this process: logind hands back a file
    # descriptor and drops the lock when it closes, so the sleep doubles as the
    # timer and nothing needs cleaning up if we're killed.
    systemd-inhibit \
        --what=sleep \
        --who="caffeine" \
        --why="$marker" \
        --mode=block \
        sleep "$duration" &
    echo $! >"$pid_file"

    if [ "$secs" -gt 0 ]; then label="for $(remaining)"; else label="until switched off"; fi
    notify-send "Caffeine on" "Automatic sleep disabled $label"
}

disable() {
    stop
    notify-send "Caffeine off" "Normal sleep behaviour restored"
}

menu() {
    local options chosen
    options="15 minutes\n30 minutes\n1 hour\n2 hours\n4 hours\nUntil switched off"
    active && options="Turn off\n$options"
    chosen=$(echo -e "$options" | rofi -dmenu -p "Caffeine" -theme custom)

    case "$chosen" in
        "Turn off") disable ;;
        "15 minutes") enable 900 ;;
        "30 minutes") enable 1800 ;;
        "1 hour") enable 3600 ;;
        "2 hours") enable 7200 ;;
        "4 hours") enable 14400 ;;
        "Until switched off") enable ;;
    esac
}

case "${1:-toggle}" in
    toggle) if active; then disable; else enable; fi ;;
    menu) menu ;;
    on) enable "${2:-0}" ;;
    off) active && disable ;;
    status)
        if active; then
            if left=$(remaining); then echo "󰅶 $left"; else echo "󰅶"; fi
        else
            echo ""
        fi
        ;;
esac
