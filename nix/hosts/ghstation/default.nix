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
      ollama
      nixGc
      podman
      containers
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

  containerServices.pihole.enable = true;

  # Only desktop with a real GPU (amdgpu, see hardware-configuration.nix), so
  # it's the one host where ROCm acceleration is worth the extra build time.
  # `services.ollama.package` comes straight from the upstream ollama module;
  # `ai.ollama.enable`/`.model` (nix/system/ollama.nix) drive everything else.
  ai.ollama.enable = true;
  services.ollama.package = pkgs.ollama-rocm;
}
