{ pkgs, ... }:

{
  home.packages = with pkgs; [
    # Nerd Fonts - adds icon glyphs for the terminal and desktop bars
    nerd-fonts.jetbrains-mono
    nerd-fonts.symbols-only
    font-awesome
  ];

  fonts.fontconfig.enable = true;
}
