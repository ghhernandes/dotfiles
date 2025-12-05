{ config, pkgs, lib, ... }:

{
  imports = [
    ./modules/clojure.nix
    ./modules/tmux.nix
    ./modules/neovim.nix
  ];

  # User settings
  home.username = lib.mkDefault "gh";
  home.homeDirectory = lib.mkDefault "/home/gh";
  home.stateVersion = "25.11";

  # Git configuration
  programs.git = {
    enable = true;
    settings = {
      user.name = "Gabriel Hernandes";
      user.email = "ghh.hernandes@gmail.com";
    };
  };

  # Zsh configuration
  programs.zsh = {
    enable = true;
    autosuggestion.enable = true;
    oh-my-zsh = {
      enable = true;
      plugins = [ "git" "fzf"];
      theme = "simple";
    };
  };

  programs.claude-code = {
    enable = true;
  };

  programs.home-manager.enable = true;

  # CLI tools
  home.packages = with pkgs; [
    btop
    fzf
    tree
    github-cli
  ];
}
