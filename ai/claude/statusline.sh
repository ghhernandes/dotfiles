#!/usr/bin/env bash
# Claude Code statusline: "<host> <model> <cwd> [<git-branch>]".
set -uo pipefail

input="$(cat)"

model="$(printf '%s' "$input" | jq -r '.model.display_name // .model.id // "claude"')"
cwd="$(printf '%s' "$input" | jq -r '.workspace.current_dir // .cwd // empty')"
[[ -z "$cwd" ]] && cwd="$PWD"

host="$(hostname -s 2>/dev/null || hostname)"

# Tilde-shorten the cwd.
if [[ "$cwd" == "$HOME" ]]; then
  short_cwd="~"
elif [[ "$cwd" == "$HOME"/* ]]; then
  short_cwd="~${cwd#$HOME}"
else
  short_cwd="$cwd"
fi

branch=""
if [[ -d "$cwd" ]]; then
  branch="$(git -C "$cwd" branch --show-current 2>/dev/null || true)"
fi

if [[ -n "$branch" ]]; then
  printf '%s %s %s [%s]\n' "$host" "$model" "$short_cwd" "$branch"
else
  printf '%s %s %s\n' "$host" "$model" "$short_cwd"
fi
