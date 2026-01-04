{ config, pkgs, ... }:

{
  programs.zsh = {
    enable = true;
    autosuggestion.enable = true;
    oh-my-zsh = {
      enable = true;
      plugins = [ "git" "fzf"];
      theme = "simple";
    };
    initContent = ''
      # Add ~/.local/bin to PATH
      export PATH="$HOME/.local/bin:$PATH"
    '';
  };
}


