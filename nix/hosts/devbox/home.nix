{ self, ... }:

{
  imports = with self.homeModules; [
    common
    cli
    git
    zsh
    localBin
    dev
    claude
    opencode
    gemini
  ];

  programs.firefox.enable = true;
}
