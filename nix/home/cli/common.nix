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
    pkgs.glow  # Markdown viewer
  ];

  # Git configuration
  programs.git = {
    enable = true;
    settings = {
      user.name = "Gabriel Hernandes";
      user.email = "ghh.hernandes@gmail.com";
    };
  };

  # Claude Code
  programs.claude-code = {
    enable = true;
  };

  # Direnv with nix-direnv for per-project dev shells
  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };
}
