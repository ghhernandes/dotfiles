{ pkgs, ... }:

{
  home.packages = with pkgs; [
    github-cli
    gemini-cli
    claude-code

    lazygit
    glow  # Markdown viewer
    mods  # AI LLM on the CLI
  ];
}
