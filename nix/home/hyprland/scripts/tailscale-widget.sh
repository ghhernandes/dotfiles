#!/usr/bin/env bash
# Tailscale connect/disconnect toggle for waybar's image module.
#   tailscale-widget toggle                       bring the tailnet up/down (default)
#   tailscale-widget status <on-icon> <off-icon>  print "$path\n$tooltip" per waybar-image(5)
#
# up/down need root unless this user is set as the tailscaled operator once:
#   sudo tailscale set --operator=$(whoami)
#
# waybar-image reads the tooltip with a single getline(), so a real \n never
# survives into it; U+2028 (LINE SEPARATOR) does survive and Pango still
# renders it as a line break, which is how this fakes a multi-line tooltip.
nl=$' '

case "${1:-toggle}" in
    toggle)
        if [ "$(tailscale status --json | jq -r .BackendState)" = "Running" ]; then
            tailscale down
        else
            tailscale up
        fi
        ;;
    status)
        on_icon="${2:?on-icon path required}"
        off_icon="${3:?off-icon path required}"
        json="$(tailscale status --json)"
        state="$(jq -r .BackendState <<<"$json")"

        if [ "$state" = "Running" ]; then
            host="$(jq -r '.Self.HostName' <<<"$json")"
            ip="$(jq -r '.Self.TailscaleIPs[0]' <<<"$json")"
            online="$(jq '[.Peer[] | select(.Online)] | length' <<<"$json")"
            total="$(jq '.Peer | length' <<<"$json")"
            printf '%s\nTailscale: connected%s%s \xe2\x80\x94 %s%sPeers online: %s/%s%sClick to disconnect\n' \
                "$on_icon" "$nl" "$host" "$ip" "$nl" "$online" "$total" "$nl"
        else
            printf '%s\nTailscale: disconnected%sClick to connect\n' "$off_icon" "$nl"
        fi
        ;;
esac
