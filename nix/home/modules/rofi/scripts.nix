{ config, pkgs, ... }:

{
  # Symlink rofi scripts to ~/.local/bin
  home.file.".local/bin/rofi-bluetooth".source =
    config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.dotfiles/scripts/rofi-bluetooth";

  home.file.".local/bin/rofi-power".source =
    config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.dotfiles/scripts/rofi-power";
}
