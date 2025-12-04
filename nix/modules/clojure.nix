{ config, pkgs, ... }:

{
  programs.java = {
    enable = true;
    package = pkgs.jdk21;
  };

  home.packages = with pkgs; [
    clojure
    clojure-lsp
    babashka
    clj-kondo
    leiningen
  ];
}
