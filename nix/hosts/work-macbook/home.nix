{ self, lib, ... }:

{
  imports = with self.homeModules; [
    common
    cli
  ];

  # Use existing ~/.gitconfig instead of home-manager managed git
  programs.git.enable = lib.mkForce false;
}
