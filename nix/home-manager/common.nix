{ config, pkgs, ... }:

{
  imports = [
    ./modules/clojure.nix
    ./modules/tmux.nix
    ./modules/neovim.nix
    ./modules/ai.nix
  ];
  programs.vscode.enable = true;
  programs.firefox.enable = true;
  programs.home-manager.enable = true;

  home.stateVersion = "25.11";

  home.packages = with pkgs; [
    vesktop
    spotify
    slack
    btop
    fzf
    tree
  ];
}
