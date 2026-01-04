{ config, pkgs, ... }:

{
  # Enable the gnome-keyring secrets vault.
  # Will be exposed through DBus to programs willing to store secrets.
  services.gnome.gnome-keyring.enable = true;

  environment.systemPackages = [
    pkgs._1password-cli
    pkgs._1password-gui
  ];
}
