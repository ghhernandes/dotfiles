_:

{
  programs.zsh = {
    enable = true;
    autosuggestion.enable = true;
    oh-my-zsh = {
      enable = true;
      plugins = [
        "git"
        "fzf"
      ];
      theme = "simple";
    };
    shellAliases = {
      t = ''claude --system-prompt "$(tony prompt)"'';
    };
    initContent = ''
      # Add ~/.local/bin to PATH
      export PATH="$HOME/.local/bin:$PATH"
    '';
  };
}
