{
  config,
  pkgs,
  pkgs-unstable,
  lib,
  dotfilesPath,
  hostName,
  ...
}:

let
  # Build-time reads (CLAUDE.md, settings.json merge) use the Nix path
  # from `dotfilesPath`, which is fine — the contents get baked into the
  # store anyway and require a rebuild to change.
  claudeRepo = dotfilesPath + "/ai/claude";
  hostRepo = claudeRepo + "/hosts/${hostName}";

  # For the live-edit symlinks we need a STRING pointing at the on-disk
  # repo, not a Nix path. Any Nix-path interpolation copies to the store,
  # which would make the symlink target a read-only store copy and defeat
  # the whole point. Deriving from `config.home.homeDirectory` keeps it a
  # plain string all the way through.
  liveDotfiles = "${config.home.homeDirectory}/.dotfiles";
  liveClaudeRepo = "${liveDotfiles}/ai/claude";

  # ---- CLAUDE.md: shared base + optional per-host append ----
  baseClaudeMd = builtins.readFile (claudeRepo + "/CLAUDE.md");
  hostClaudeMdPath = hostRepo + "/CLAUDE.md";
  hostClaudeMd =
    if builtins.pathExists hostClaudeMdPath then builtins.readFile hostClaudeMdPath else "";
  mergedClaudeMd = if hostClaudeMd == "" then baseClaudeMd else baseClaudeMd + "\n" + hostClaudeMd;

  # ---- settings.json: shared base recursiveUpdate-merged with host override ----
  baseSettings = builtins.fromJSON (builtins.readFile (claudeRepo + "/settings.json"));
  hostSettingsPath = hostRepo + "/settings.json";
  hostSettings =
    if builtins.pathExists hostSettingsPath then
      builtins.fromJSON (builtins.readFile hostSettingsPath)
    else
      { };
  mergedSettings = lib.recursiveUpdate baseSettings hostSettings;

  settingsFile = (pkgs.formats.json { }).generate "claude-settings.json" mergedSettings;

  # ---- Live-edit out-of-store symlinks ----
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
  # jq is needed by the hook scripts and statusline; nixfmt-rfc-style is
  # what the repo already uses for .nix formatting. coreutils is implied
  # but listed explicitly so hooks work on a fresh host before the shell
  # profile populates PATH.
  home.packages = [
    pkgs-unstable.claude-code
    pkgs.jq
    pkgs.nixfmt-rfc-style
    pkgs.coreutils
  ];

  programs.claude-code.enable = true;

  home.file = liveFiles // {
    ".claude/CLAUDE.md".text = mergedClaudeMd;
    ".claude/settings.json".source = settingsFile;
  };
}
