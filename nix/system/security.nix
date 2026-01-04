{ config, pkgs, ... }:

{
  # Enable the gnome-keyring secrets vault.
  # Will be exposed through DBus to programs willing to store secrets.
  services.gnome.gnome-keyring.enable = true;

  environment.systemPackages = with pkgs; [
    _1password-cli
    _1password-gui
  ];
}
