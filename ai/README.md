# AI tool configs

Home-manager-managed configuration for AI tools, shared identically across
every host. The nix glue lives in `../nix/home/ai/` and is wired into hosts
through the single `homeModules.ai` in `../nix/flake.nix`.

## Layout

```
ai/
├── claude/
│   ├── CLAUDE.md           # global instructions
│   ├── settings.json       # settings.json
│   ├── statusline.sh       # custom statusline script (live-edit)
│   ├── hooks/              # PreToolUse / PostToolUse hook scripts (live-edit)
│   │   ├── protect-secrets.sh
│   │   └── nixfmt-on-write.sh
│   ├── agents/              # custom subagents (live-edit, empty until populated)
│   ├── skills/                # custom skills (live-edit, empty until populated)
│   └── commands/                # slash commands (live-edit, empty until populated)
└── opencode/
    ├── opencode.json
    └── tui.json
```

Every host gets the same files — there is no per-host override directory.
If a host ever needs to skip a tool entirely, set `ai.<tool>.enable = false;`
in that host's `home.nix` (see `../nix/home/ai/default.nix` for the options).

## Two kinds of files (Claude Code)

### Store-baked (require `home-manager switch` to update)

- `CLAUDE.md`, `settings.json` — copied into the nix store;
  `~/.claude/CLAUDE.md` / `~/.claude/settings.json` are read-only symlinks
  into the store. Edit them in `ai/claude/` and rebuild.

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

1. Edit `ai/claude/CLAUDE.md` or `ai/claude/settings.json` (or the
   `ai/opencode/*.json` equivalents).
2. From `~/.dotfiles/nix`:
   ```bash
   home-manager switch --flake .#<host>
   ```

## Adding a new AI tool

1. Create `ai/<tool>/` with its config files.
2. Create `nix/home/ai/<tool>.nix` following the shape of `claude.nix` /
   `opencode.nix`: read files straight out of `ai/<tool>/`, gate the whole
   `config` block behind `lib.mkIf config.ai.<tool>.enable`.
3. Add it to `imports` and declare its `enable` option in
   `nix/home/ai/default.nix`.

No `flake.nix` or per-host `home.nix` edits needed — every host already
imports the single `ai` module.

## What is NOT managed

Runtime state and credentials are deliberately untouched so nix activation
never clobbers them:

`.credentials.json`, `.claude.json`, `projects/`, `plugins/`, `cache/`,
`backups/`, `sessions/`, `shell-snapshots/`, `file-history/`, `plans/`,
`tasks/`, `todos/`.
