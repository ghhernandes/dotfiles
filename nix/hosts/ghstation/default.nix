{
  self,
  pkgs,
  lanzaboote,
  ...
}:

{
  imports =
    (with self.systemModules; [
      ./hardware-configuration.nix
      ./services.nix
      audio
      bluetooth
      gaming
      virtualization
      hyprland
      remoteAccess
      monitoring
      security
      packageManagers
    ])
    ++ [
      lanzaboote.nixosModules.lanzaboote
    ];

  users.users.gh = {
    isNormalUser = true;
    description = "Gabriel";
    extraGroups = [
      "networkmanager"
      "wheel"
      "gamemode"
    ];
    shell = pkgs.zsh;
  };

  networking.hostName = "ghstation";
  networking.networkmanager.enable = true;

  programs.zsh.enable = true;
}
