{ config, pkgs, ... }:

{
  imports = [
    ./modules/clojure.nix
    ./modules/tmux.nix
    ./modules/ai.nix
  ];
  home.stateVersion = "25.11"; 

  home.username = "gh";
  home.homeDirectory = "/home/gh";

  home.packages = with pkgs; [
    neovim

    vesktop
    spotify
    slack
  ];

  programs.vscode.enable = true;

  programs.firefox.enable = true;
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

  programs.home-manager.enable = true;
}
