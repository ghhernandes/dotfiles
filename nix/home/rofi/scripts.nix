{ config, pkgs, ... }:

{
  home.file.".local/bin/gh-system-bluetooth".source =
    config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.dotfiles/local-bin/gh-system-bluetooth";

  home.file.".local/bin/gh-system-power".source =
    config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.dotfiles/local-bin/gh-system-power";

  home.file.".local/bin/gh-screenshot".source =
    config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.dotfiles/local-bin/gh-screenshot";

  home.file.".local/bin/gh-pomodoro".source =
    config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.dotfiles/local-bin/gh-pomodoro";
}
