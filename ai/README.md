# AI tool configs

Home-manager-managed configuration for AI tools, shared across all hosts with
per-host overrides. Today this tree only contains `claude/` (Claude Code);
siblings like `aider/`, `codex/`, etc. can be added later under the same
`ai/<tool>/` layout.

The nix glue lives in `../nix/home/ai/` and is wired into every host through
`homeModules.ai` in `../nix/flake.nix`.

## Layout

```
ai/
└── claude/
    ├── CLAUDE.md           # shared global instructions (base)
    ├── settings.json       # shared base settings.json
    ├── statusline.sh       # custom statusline script (live-edit)
    ├── hooks/              # PreToolUse / PostToolUse hook scripts (live-edit)
    │   ├── protect-secrets.sh
    │   └── nixfmt-on-write.sh
    ├── agents/             # custom subagents (live-edit, empty until populated)
    ├── skills/             # custom skills (live-edit, empty until populated)
    ├── commands/           # slash commands (live-edit, empty until populated)
    └── hosts/
        ├── callisto/       # per-host overrides (optional)
        │   ├── CLAUDE.md       # appended to the shared base
        │   └── settings.json   # recursiveUpdate-merged on top of base
        ├── ghstation/
        └── devbox/
```

## Two kinds of files

The module handles two categories differently on purpose:

### Store-baked (require `home-manager switch` to update)

- `CLAUDE.md` — shared base, concatenated with `hosts/<host>/CLAUDE.md` at
  build time.
- `settings.json` — shared base, `lib.recursiveUpdate`-merged with
  `hosts/<host>/settings.json` at build time (host wins on conflicts).

These land in the nix store and `~/.claude/CLAUDE.md` / `~/.claude/settings.json`
are read-only symlinks into the store. Edit them in `ai/claude/` and rebuild.

### Live-edit (symlinks straight to the repo, no rebuild needed)

- `agents/`, `skills/`, `commands/`, `hooks/`, `statusline.sh`

These are wired via `config.lib.file.mkOutOfStoreSymlink` so
`~/.claude/hooks/foo.sh` resolves all the way to
`~/.dotfiles/ai/claude/hooks/foo.sh`. You can edit either path — they're the
same file — and Claude Code picks up the change on the next turn. No rebuild,
no activation.

Caveat on editing: most editors (vim, nano, `$EDITOR`) edit the real file in
place and are fine. Editors that do atomic-replace-on-save may replace the
symlink itself with a regular file, breaking the live link until the next
`home-manager switch`. If in doubt, edit under `~/.dotfiles/ai/claude/`
directly — that's where you'd run `git` anyway.

## Per-host overrides

Any file under `hosts/<hostname>/` is optional. The module checks existence
and silently skips missing files.

- `hosts/<host>/CLAUDE.md` → appended to the shared base with a blank-line
  separator. Use it for host-specific environment notes (`callisto` carries
  the WSL + rebuild commands, for example).
- `hosts/<host>/settings.json` → `lib.recursiveUpdate base hostOverride`,
  so the host file only needs to name the keys it wants to change.

To add a new host override, just create the file; no nix edits needed.

## Bundled hook scripts

`hooks/protect-secrets.sh` (PreToolUse, matcher `Read|Edit|Write|MultiEdit`)
reads the tool call JSON on stdin and denies the call via
`hookSpecificOutput.permissionDecision = "deny"` if the `file_path` matches:

- exact basenames: `.credentials.json`, `.env`, `id_rsa`, `id_ed25519`,
  `id_ecdsa`, `id_dsa`
- `.env.*` variants (e.g. `.env.local`, `.env.production`)
- anything under `secrets/`
- anything under `.ssh/*_key*` or `.gnupg/`

Unmatched paths exit 0 (allow).

`hooks/nixfmt-on-write.sh` (PostToolUse, matcher `Edit|Write|MultiEdit`)
runs `nixfmt` on the just-written file if it ends in `.nix`. Best-effort —
any failure exits 0 so a formatter hiccup never breaks a turn.

`statusline.sh` reads the statusline JSON and emits
`<short-host> <model> <cwd-tilde-shortened> [<git-branch>]`.

## Adding a new agent / skill / slash command

Drop the file into `ai/claude/agents/`, `ai/claude/skills/`, or
`ai/claude/commands/` — no nix changes needed. The module already symlinks
the whole directory. Iterate freely; everything round-trips without a
rebuild.

## Changing base settings or shared CLAUDE.md

1. Edit `ai/claude/CLAUDE.md` or `ai/claude/settings.json`.
2. From `~/.dotfiles/nix`:
   ```bash
   home-manager switch --flake .#<host>
   ```
3. `~/.claude/CLAUDE.md` and `~/.claude/settings.json` will now point at new
   store paths reflecting the edit.

## What is NOT managed

Runtime state and credentials are deliberately untouched so nix activation
never clobbers them:

`.credentials.json`, `.claude.json`, `projects/`, `plugins/`, `cache/`,
`backups/`, `sessions/`, `shell-snapshots/`, `file-history/`, `plans/`,
`tasks/`, `todos/`.
