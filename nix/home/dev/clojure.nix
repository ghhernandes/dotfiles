{ config, pkgs, ... }:

{
  programs.java = {
    enable = true;
    package = pkgs.jdk21;
  };

  home.packages = [
    pkgs.clojure
    pkgs.clojure-lsp
    pkgs.babashka
    pkgs.clj-kondo
    pkgs.leiningen
  ];
}
