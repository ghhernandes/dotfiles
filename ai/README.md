# AI tool configs

Home-manager-managed configuration for AI tools, shared identically across
every host. The nix glue is the single file `../nix/home/ai.nix`, wired into
hosts through `homeModules.ai` in `../nix/flake.nix`.

## Layout

```
ai/
├── claude/
│   ├── CLAUDE.md           # global instructions
│   ├── MEMORY.md           # global memory conventions
│   ├── SELF_IMPROVE.md     # self-improving skill loop
│   ├── settings.json
│   ├── statusline.sh
│   ├── skills/
│   └── hooks/              # PreToolUse / PostToolUse scripts
│       ├── protect-secrets.sh
│       └── nixfmt-on-write.sh
└── opencode/
    ├── opencode.json
    └── tui.json
```

## How files reach `$HOME`

Everything is a symlink from `~/.claude/` or `~/.config/opencode/` straight
to this directory, so edits apply immediately with no rebuild. Claude Code
may write to these files itself (`/model`, `/config`, permission prompts,
skills); review `git diff` before committing.

The one exception is `hooks/`: it is copied into the nix store and is
read-only, so Claude cannot rewrite the scripts that guard its own tool
calls. Edit them here and run `home-manager switch --flake .#<host>` from
`../nix`.

To link another file, add one line to `home.file` (or `xdg.configFile`) in
`../nix/home/ai.nix`.

## Hooks

`protect-secrets.sh` (PreToolUse, `Read|Edit|Write|MultiEdit`) denies calls
whose `file_path` is `.credentials.json`, `.env`, `.env.*`, an SSH key,
anything under `secrets/`, `.ssh/*_key*` or `.gnupg/`.

`nixfmt-on-write.sh` (PostToolUse, `Edit|Write|MultiEdit`) runs `nixfmt` on
written `.nix` files; failures never break a turn.

## Not managed

Runtime state and credentials stay untouched: `.credentials.json`,
`.claude.json`, `projects/`, `plugins/`, `cache/`, `backups/`, `sessions/`,
`shell-snapshots/`, `file-history/`, `plans/`, `tasks/`, `todos/`.
