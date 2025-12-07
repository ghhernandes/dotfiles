# common.nix file is to define the baseline environment 
# that must exists on every single machine

# use profiles/ to create group of different modules.
# Eg: server, homelab, etc.

{ config, pkgs, lib, ... }:

{
  imports = [
    ./modules/tmux.nix
    ./modules/neovim.nix
    ./modules/zsh.nix
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

  programs.claude-code = {
    enable = true;
  };

  programs.home-manager.enable = true;

  # CLI tools
  home.packages = with pkgs; [
    btop
    fzf
    tree
    ripgrep
  ];
}
