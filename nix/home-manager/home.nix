{ config, pkgs, ... }:

{
  imports = [
    ./common.nix
   ];

  home.username = "gh";
  home.homeDirectory = "/home/gh";

  programs.git = {
    enable = true;
    settings = {
      user.name = "Gabriel Hernandes";
      user.email = "ghh.hernandes@gmail.com";
    };
  };

  programs.zsh = {
    enable = true;
    autosuggestion.enable = true;
    oh-my-zsh = {
      enable = true;
      plugins = [ "git" "fzf"];
      theme = "simple";
    };
  };
}
