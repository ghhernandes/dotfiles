{
  config,
  pkgs,
  dotfilesPath,
  ...
}:

let
  # Live links: a string path, not a Nix path, so the target stays the
  # on-disk repo instead of a read-only store copy.
  repo = "${config.home.homeDirectory}/.dotfiles/ai";
  link = path: config.lib.file.mkOutOfStoreSymlink "${repo}/${path}";
in
{
  home.packages = with pkgs; [
    claude-code
    opencode
    jq
    nixfmt
    coreutils
  ];

  home.file = {
    ".claude/settings.json".source = link "claude/settings.json";
    ".claude/CLAUDE.md".source = link "claude/CLAUDE.md";
    ".claude/MEMORY.md".source = link "claude/MEMORY.md";
    ".claude/SELF_IMPROVE.md".source = link "claude/SELF_IMPROVE.md";
    ".claude/statusline.sh".source = link "claude/statusline.sh";
    ".claude/skills".source = link "claude/skills";
    # Store copy on purpose: these scripts police Claude's tool calls, so
    # Claude must not be able to rewrite them in place.
    ".claude/hooks".source = dotfilesPath + "/ai/claude/hooks";
  };

  xdg.configFile = {
    "opencode/opencode.json".source = link "opencode/opencode.json";
    "opencode/tui.json".source = link "opencode/tui.json";
  };

  # Runtime state that grows over sessions, so it must stay writable.
  systemd.user.tmpfiles.rules = [
    "d %h/.gh/global-memory 0755 - - - -"
    "f %h/.gh/global-memory/MEMORY.md 0644 - - - -"
  ];
}
