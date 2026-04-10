#!/usr/bin/env bash
# PreToolUse hook: block Read/Edit/Write/MultiEdit on sensitive files.
#
# Reads the tool call JSON from stdin, extracts tool_input.file_path, and
# denies the call if the path matches any known-sensitive pattern. Any
# non-match (or missing file_path) is allowed by exiting 0 with no output.
set -euo pipefail

input="$(cat)"
file_path="$(printf '%s' "$input" | jq -r '.tool_input.file_path // empty')"

if [[ -z "$file_path" ]]; then
  exit 0
fi

# Normalize: strip leading ./ but keep absolute paths intact.
path="${file_path#./}"
base="$(basename -- "$path")"

deny() {
  local reason="$1"
  jq -cn --arg reason "$reason" '{
    hookSpecificOutput: {
      hookEventName: "PreToolUse",
      permissionDecision: "deny",
      permissionDecisionReason: $reason
    }
  }'
  exit 0
}

# Exact basenames that are always secret-bearing.
case "$base" in
  .credentials.json|.env|id_rsa|id_ed25519|id_ecdsa|id_dsa)
    deny "Blocked: $base is a secrets file (protect-secrets hook)."
    ;;
esac

# .env.* variants (e.g. .env.local, .env.production).
if [[ "$base" == .env.* ]]; then
  deny "Blocked: $base is a dotenv variant (protect-secrets hook)."
fi

# SSH private keys and GnuPG internals live under these directories.
case "$path" in
  *secrets/*|secrets/*)
    deny "Blocked: paths under secrets/ are off-limits (protect-secrets hook)."
    ;;
  *.ssh/*_key|*.ssh/*_key.*|*.ssh/id_*|*/.gnupg/*|*.gnupg/*)
    deny "Blocked: $path looks like a private key or gnupg asset (protect-secrets hook)."
    ;;
esac

exit 0
