#!/usr/bin/env bash
# Set/clear the tmux @icon user-option on the current window.
# Usage: tmux-tag.sh [icon]   — empty / missing arg clears the icon.

set -u
icon="${1-}"

[[ -n "${TMUX_PANE:-}" ]] || exit 0
command -v tmux >/dev/null 2>&1 || exit 0

if [[ -z "$icon" ]]; then
  tmux set-option -w -t "$TMUX_PANE" -u @icon >/dev/null 2>&1
else
  tmux set-option -w -t "$TMUX_PANE" @icon "$icon" >/dev/null 2>&1
fi
exit 0
