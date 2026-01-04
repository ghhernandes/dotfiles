{ config, pkgs, ... }:

{
  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true;
    dedicatedServer.openFirewall = true;
    localNetworkGameTransfers.openFirewall = true;
  };

  programs.gamemode.enable = true;

  environment.systemPackages = [
    pkgs.gamemode
    pkgs.gamescope
    pkgs.mangohud
    pkgs.lutris
    pkgs.heroic
    pkgs.gogdl
  ];
}
