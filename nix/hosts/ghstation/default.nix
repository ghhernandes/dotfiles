{ inputs, config, pkgs, lanzaboote, system, ... }:

{
  imports =
    [
      ./hardware-configuration.nix
      ./poweroff-corsair-leds.nix
      ./node-exporter.nix
      ./sunshine.nix
    ];

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

  # Enable the gnome-keyring secrets vault. 
  # Will be exposed through DBus to programs willing to store secrets.
  services.gnome.gnome-keyring.enable = true;

  # enable Hyprland window manager
  programs.hyprland = {
    enable = true;
    withUWSM = true;  # recommended for NixOS 24.11+
    xwayland.enable = true;
  };

  # Enable Wayland support for Electron apps
  environment.sessionVariables.NIXOS_OZONE_WL = "1";

  programs.appimage.enable = true;
  services.flatpak.enable = true;
  xdg.portal = {
    enable = true;
    extraPortals = with pkgs; [ xdg-desktop-portal-hyprland ];
  };

  environment.systemPackages = with pkgs; [
    _1password-cli
    _1password-gui

    gamemode
    mangohud

    lutris
    heroic
    gogdl

    sunshine

    grim # screenshot functionality
    slurp # screenshot functionality
    wl-clipboard # wl-copy and wl-paste for copy/paste from stdin / stdout
  ];
}

