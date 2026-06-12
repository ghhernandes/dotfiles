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

  programs.delta = {
    enable = true;
    enableGitIntegration = true;
    options = {
      navigate = true;
      line-numbers = true;
      side-by-side = true;
      syntax-theme = "Monokai Extended";
    };
  };
}
