{ self, config, pkgs, ... }:

{
  imports = with self.systemModules; [
    ./hardware-configuration.nix
    audio
    security
  ];

  users.users.gh = {
    isNormalUser = true;
    description = "Gabriel";
    extraGroups = [ "networkmanager" "wheel" ];
    shell = pkgs.zsh;
  };

  networking.hostName = "devbox";
  networking.networkmanager.enable = true;

  programs.zsh.enable = true;

  # GNOME Desktop
  services.xserver.enable = true;
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome.enable = true;
  services.xserver.videoDrivers = [ "modesetting" "fbdev" ];

  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  services.printing.enable = true;
}
