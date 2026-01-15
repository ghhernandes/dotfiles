{ config, pkgs, ... }:

{
  home.packages = with pkgs; [
    # Nerd Fonts - adds icon support for terminal and waybar
    nerd-fonts.jetbrains-mono
    nerd-fonts.symbols-only
    font-awesome
  ];

  fonts.fontconfig.enable = true;
}
