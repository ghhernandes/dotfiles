{ config, pkgs, dotfilesPath, ... }:
{
  home.packages = with pkgs; [
    emacs
    git
    (ripgrep.override {withPCRE2 = true;})
    fd
  ];

  xdg.configFile."doom" = {
    source = "${dotfilesPath}/doom";
    recursive = true;
  };

  home.sessionPath = [
    "$HOME/.config/emacs/bin"
  ];
}
