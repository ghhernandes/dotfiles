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
    pkgs.antigravity

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

  # GTK theming. Without an explicit icon theme, GTK apps (Nautilus, ...) fall
  # back to the broken hicolor set and render generic/ugly icons. libadwaita
  # apps ignore the GTK *theme* but do honor the icon theme and the
  # color-scheme preference set below.
  gtk = {
    enable = true;
    theme = {
      name = "adw-gtk3-dark";
      package = pkgs.adw-gtk3;
    };
    iconTheme = {
      name = "Papirus-Dark";
      package = pkgs.papirus-icon-theme;
    };
    # adw-gtk3 ships GTK4 CSS too, so theme non-libadwaita GTK4 apps to match.
    # Pinned explicitly because the HM default flips to null at stateVersion 26.05.
    gtk4.theme = {
      name = "adw-gtk3-dark";
      package = pkgs.adw-gtk3;
    };
  };

  # Dark mode for libadwaita / GTK4 apps, and the icon/theme names for anything
  # reading gsettings directly.
  dconf.settings."org/gnome/desktop/interface" = {
    color-scheme = "prefer-dark";
    icon-theme = "Papirus-Dark";
    gtk-theme = "adw-gtk3-dark";
  };

  # Qt apps (kdenlive, OBS, ...) follow the GTK look instead of default Fusion.
  qt = {
    enable = true;
    platformTheme.name = "gtk3";
  };
}
