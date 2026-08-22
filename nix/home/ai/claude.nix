{
  config,
  pkgs,
  lib,
  dotfilesPath,
  ...
}:

let
  claudeRepo = dotfilesPath + "/ai/claude";

  # For the live-edit symlinks we need a STRING pointing at the on-disk
  # repo, not a Nix path. Any Nix-path interpolation copies to the store,
  # which would make the symlink target a read-only store copy and defeat
  # the whole point. Deriving from `config.home.homeDirectory` keeps it a
  # plain string all the way through.
  liveDotfiles = "${config.home.homeDirectory}/.dotfiles";
  liveClaudeRepo = "${liveDotfiles}/ai/claude";

  # Existence is checked via the build-time Nix path (so we don't symlink
  # to a directory that doesn't exist yet), but the symlink target uses the
  # on-disk string path so edits round-trip without a rebuild.
  maybeSymlink =
    relPath: target:
    lib.optionalAttrs (builtins.pathExists (claudeRepo + "/${relPath}")) {
      "${target}".source = config.lib.file.mkOutOfStoreSymlink "${liveClaudeRepo}/${relPath}";
    };

  liveFiles =
    (maybeSymlink "agents" ".claude/agents")
    // (maybeSymlink "skills" ".claude/skills")
    // (maybeSymlink "commands" ".claude/commands")
    // (maybeSymlink "hooks" ".claude/hooks")
    // (maybeSymlink "statusline.sh" ".claude/statusline.sh");
in
{
  config = lib.mkIf config.ai.claude.enable {
    # jq is needed by the hook scripts and statusline; nixfmt-rfc-style is
    # what the repo already uses for .nix formatting. coreutils is implied
    # but listed explicitly so hooks work on a fresh host before the shell
    # profile populates PATH.
    home.packages = [
      pkgs.claude-code
      pkgs.jq
      pkgs.nixfmt
      pkgs.coreutils
    ];

    home.file = liveFiles // {
      ".claude/CLAUDE.md".source = claudeRepo + "/CLAUDE.md";
      ".claude/MEMORY.md".source = claudeRepo + "/MEMORY.md";
      ".claude/SELF_IMPROVE.md".source = claudeRepo + "/SELF_IMPROVE.md";
      ".claude/settings.json".source = claudeRepo + "/settings.json";
    };

    # Runtime state, not config -- grows over sessions, so it must stay
    # writable (a nix store path, unlike the files above, would be
    # read-only and defeat the whole point). `f` only creates the index if
    # missing; it never touches it again once memories start accumulating.
    systemd.user.tmpfiles.rules = [
      "d %h/.gh/global-memory 0755 - - - -"
      "f %h/.gh/global-memory/MEMORY.md 0644 - - - -"
    ];
  };
}
