{ pkgs, ... }:

{
  # CLI Applications and Tools
  home.packages = [
    # System monitoring
    pkgs.btop

    # Core CLI tools
    pkgs.fzf
    pkgs.tree
    pkgs.ripgrep

    # Git and version control
    pkgs.github-cli
    pkgs.lazygit

    # AI/LLM tools
    pkgs.claude-code
    pkgs.mods

    # TUI applications
    pkgs.glow # Markdown viewer
  ];

  programs = {
    # Git configuration
    git = {
      enable = true;
      settings = {
        user.name = "Gabriel Hernandes";
        user.email = "ghh.hernandes@gmail.com";
      };
    };

    # Claude Code
    claude-code = {
      enable = true;
    };

    # Direnv with nix-direnv for per-project dev shells
    direnv = {
      enable = true;
      nix-direnv.enable = true;
    };
  };
}
