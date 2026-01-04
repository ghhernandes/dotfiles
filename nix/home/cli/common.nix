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
    pkgs.gemini-cli
    pkgs.claude-code
    pkgs.mods

    # TUI applications
    pkgs.impala
    pkgs.bluetui
    pkgs.glow  # Markdown viewer

    # Security/Yubikey CLI
    pkgs.yubikey-manager
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
}
