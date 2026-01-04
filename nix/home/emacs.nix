{ config, pkgs, dotfilesPath, ... }:
{
  home.packages = [
    pkgs.emacs
    pkgs.git
    (pkgs.ripgrep.override {withPCRE2 = true;})
    pkgs.fd
  ];

  xdg.configFile."doom" = {
    source = "${dotfilesPath}/doom";
    recursive = true;
  };

  home.sessionPath = [
    "$HOME/.config/emacs/bin"
  ];
}
