{ config, pkgs, ...}:
{
  home.packages = with pkgs; [
    emacs
    git
    (ripgrep.override {withPCRE2 = true;})
    fd
  ];

  xdg.configFile."doom" = {
    source = ../../../doom;
    recursive = true;
  };

  home.sessionPath = [
    "$HOME/.config/emacs/bin"
  ];
}
