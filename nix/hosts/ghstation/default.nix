{ inputs, config, pkgs, system, ... }:

{
  imports =
    [ 
      ./hardware-configuration.nix
    ];

  nixpkgs.config.allowUnfree = true;

  users.users.gh = {
    isNormalUser = true;
    description = "Gabriel";
    extraGroups = [ "networkmanager" "wheel" ];
    shell = pkgs.zsh;
  };

  zramSwap.enable = true;

  networking.hostName = "ghstation"; 

  networking.networkmanager.enable = true;

  services.xserver.enable = true;

  services.displayManager.gdm.enable = true;
  services.displayManager.gdm.autoSuspend = false;
  services.desktopManager.gnome.enable = true;

  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  services.tailscale.enable = true;

  programs.zsh.enable = true;

  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true;
    dedicatedServer.openFirewall = true;
    localNetworkGameTransfers.openFirewall = true;
  };

  programs.gamemode.enable = true;

  programs.appimage.enable = true;
  services.flatpak.enable = true;
  xdg.portal.enable = true;

  programs._1password.enable = true;
  programs._1password-gui.enable = true;

  environment.systemPackages = with pkgs; [
    lutris

    heroic
    gogdl
  ];
}

