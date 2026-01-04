{ pkgs, ... }:

{
  home.packages = [
    pkgs.github-cli
    pkgs.gemini-cli
    pkgs.claude-code

    pkgs.lazygit
    pkgs.glow  # Markdown viewer
    pkgs.mods  # AI LLM on the CLI
  ];
}
