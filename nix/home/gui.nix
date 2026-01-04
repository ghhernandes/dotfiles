{ pkgs, ... }:

{
  # GUI Applications
  home.packages = [
    pkgs.nautilus
    pkgs.loupe

    # Browsers
    pkgs.firefox
    pkgs.google-chrome

    # Editors/IDEs
    pkgs.vscode
    pkgs.obsidian

    # Media
    pkgs.spotify
    pkgs.gimp
    pkgs.pinta
    pkgs.mpv
    pkgs.obs-studio
    pkgs.kdePackages.kdenlive

    # Messaging/Communication
    pkgs.vesktop
    pkgs.slack
    pkgs.signal-desktop

    # Security/Yubikey GUI
    pkgs.yubioath-flutter
  ];
}
