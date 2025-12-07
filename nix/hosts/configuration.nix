{ config, nixpkgs, ... }:
{
  # Apply custom overlays
  nixpkgs.overlays = import ../overlays;

  nixpkgs.config.allowUnfree = true;

  system.autoUpgrade.enable = true;

  time.timeZone = "America/Sao_Paulo";

  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "pt_BR.UTF-8";
    LC_IDENTIFICATION = "pt_BR.UTF-8";
    LC_MEASUREMENT = "pt_BR.UTF-8";
    LC_MONETARY = "pt_BR.UTF-8";
    LC_NAME = "pt_BR.UTF-8";
    LC_NUMERIC = "pt_BR.UTF-8";
    LC_PAPER = "pt_BR.UTF-8";
    LC_TELEPHONE = "pt_BR.UTF-8";
    LC_TIME = "pt_BR.UTF-8";
  };

  nix.settings.experimental-features = "nix-command flakes";
  nix.settings.trusted-users = [ "root" "gh" ];

  system.stateVersion = "25.11"; 
}
