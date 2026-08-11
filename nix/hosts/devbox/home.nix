{ self, ... }:

{
  imports = with self.homeModules; [
    common
    cli
    git
    zsh
    dev
    claude
    opencode
    gemini
  ];

  programs.firefox.enable = true;
}
