{
  description = "ghhernandes NixOS configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.11";

    lanzaboote = {
      url = "github:nix-community/lanzaboote/v1.0.0";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager.url = "github:nix-community/home-manager/release-25.11";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    claude-code.url = "github:sadjow/claude-code-nix";

    nixos-wsl = {
      url = "github:nix-community/NixOS-WSL/main";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    systems.url = "github:nix-systems/default";
  };

  outputs = { self, nixpkgs, home-manager, lanzaboote, claude-code, nixos-wsl, ...}@inputs:
  let
    hostOutputs = import ./hosts {
      inherit self nixpkgs home-manager lanzaboote claude-code inputs;
      system = "x86_64-linux";
    };
  in
  {
    homeModules = {
      common = ./home/common.nix;
      cli = ./home/cli;
      cliHardware = ./home/cli/hardware.nix;
      gui = ./home/gui.nix;
      emacs = ./home/emacs.nix;
      kitty = ./home/kitty.nix;
      fonts = ./home/fonts.nix;
      localBin = ./home/local-bin.nix;
      dev = ./home/dev;
      hyprland = ./home/hyprland;
      rofi = ./home/rofi;
      reverseEngineering = ./home/reverse-engineering.nix;
      ai = ./home/ai;
    };

    systemModules = {
      audio = ./system/audio.nix;
      bluetooth = ./system/bluetooth.nix;
      gaming = ./system/gaming.nix;
      virtualization = ./system/virtualization.nix;
      hyprland = ./system/hyprland.nix;
      remoteAccess = ./system/remote-access.nix;
      monitoring = ./system/monitoring.nix;
      security = ./system/security.nix;
      packageManagers = ./system/package-managers.nix;
      docker = ./system/docker.nix;
    };

    inherit (hostOutputs) nixosConfigurations homeConfigurations;
  };
}
