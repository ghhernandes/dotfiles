{ config, pkgs, ... }:

{
  home.file.".local/bin/rofi-bluetooth".source =
    config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.dotfiles/local-bin/rofi-bluetooth";

  home.file.".local/bin/rofi-power".source =
    config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.dotfiles/local-bin/rofi-power";

  home.file.".local/bin/hypr-screenshot".source =
    config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.dotfiles/local-bin/hypr-screenshot";
}
