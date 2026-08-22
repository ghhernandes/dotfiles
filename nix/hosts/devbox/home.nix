{ self, ... }:

{
  imports = with self.homeModules; [
    common
    cli
    git
    zsh
    dev
    ai
  ];

  programs.firefox.enable = true;
}
