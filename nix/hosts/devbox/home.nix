{ self, ... }:

{
  imports = with self.homeModules; [
    common
    cli
    localBin
    dev
    claude
    opencode
    gemini
  ];

  programs.firefox.enable = true;
}
