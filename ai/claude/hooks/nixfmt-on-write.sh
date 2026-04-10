#!/usr/bin/env bash
# PostToolUse hook: run nixfmt on .nix files after Edit/Write/MultiEdit.
#
# Best-effort: any failure exits 0 so a formatter hiccup never blocks a turn.
set -uo pipefail

input="$(cat)"
file_path="$(printf '%s' "$input" | jq -r '.tool_input.file_path // empty' 2>/dev/null || true)"

if [[ -z "$file_path" ]]; then
  exit 0
fi

if [[ "$file_path" != *.nix ]]; then
  exit 0
fi

if [[ ! -f "$file_path" ]]; then
  exit 0
fi

if ! command -v nixfmt >/dev/null 2>&1; then
  exit 0
fi

nixfmt "$file_path" >/dev/null 2>&1 || true
exit 0
