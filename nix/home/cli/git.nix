{ pkgs, ... }:

{
  home.packages = [
    pkgs.github-cli
    pkgs.lazygit
  ];

  programs.git = {
    enable = true;
    settings = {
      user.name = "Gabriel Hernandes";
      user.email = "ghh.hernandes@gmail.com";
    };
  };
}
