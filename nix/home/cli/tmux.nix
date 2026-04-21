{
  pkgs,
  dotfilesPath,
  ...
}:

let
  tmux-session-manager = pkgs.writeShellApplication {
    name = "tmux-session-manager";
    runtimeInputs = with pkgs; [
      tmux
      fzf
      findutils
      coreutils
      procps
    ];
    text = builtins.readFile "${dotfilesPath}/tmux/tmux-session-manager";
  };
in
{
  home.packages = [
    tmux-session-manager
  ];

  programs.tmux = {
    enable = true;
    clock24 = true;
    extraConfig = builtins.readFile "${dotfilesPath}/tmux/tmux.conf";
  };
}
