{ inputs, config, pkgs, lanzaboote, system, ... }:

{
  imports =
    [
      ./hardware-configuration.nix
      ./poweroff-corsair-leds.nix
      ./node-exporter.nix
    ];

  nixpkgs.config.allowUnfree = true;

  users.users.gh = {
    isNormalUser = true;
    description = "Gabriel";
    extraGroups = [ "networkmanager" "wheel" "gamemode" ];
    shell = pkgs.zsh;
  };

  networking.hostName = "ghstation"; 
  networking.networkmanager.enable = true;

  virtualisation.libvirtd.enable = true;
  programs.virt-manager.enable = true;

  zramSwap.enable = true;

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

  programs.appimage.enable = true;
  services.flatpak.enable = true;
  xdg.portal.enable = true;

  environment.systemPackages = with pkgs; [
    _1password-cli
    _1password-gui

    gamemode
    mangohud

    lutris
    heroic
    gogdl

    sbctl
  ];
}

