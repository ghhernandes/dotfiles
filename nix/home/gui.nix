{ pkgs, ... }:

{
  # GUI Applications
  home.packages = [
    # Browsers
    pkgs.firefox
    pkgs.google-chrome

    # Editors/IDEs
    pkgs.vscode

    # Media
    pkgs.spotify
    pkgs.gimp

    # Messaging/Communication
    pkgs.vesktop
    pkgs.slack

    # Security/Yubikey GUI
    pkgs.yubioath-flutter
  ];
}
