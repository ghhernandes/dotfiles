{
  description = "ghhernandes NixOS configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-26.05";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

    lanzaboote = {
      url = "github:nix-community/lanzaboote/v1.0.0";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs-unstable";

    nix-index-database = {
      url = "github:nix-community/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixos-wsl = {
      url = "github:nix-community/NixOS-WSL/main";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    systems.url = "github:nix-systems/default";
  };

  outputs =
    {
      self,
      nixpkgs,
      home-manager,
      lanzaboote,
      ...
    }@inputs:
    let
      hostOutputs = import ./hosts {
        inherit
          self
          nixpkgs
          home-manager
          lanzaboote
          inputs
          ;
      };
    in
    {
      homeModules = {
        common = ./home/common.nix;
        cli = ./home/cli;
        git = ./home/cli/git.nix;
        zsh = ./home/cli/zsh.nix;
        cliHardware = ./home/cli/hardware.nix;
        gui = ./home/gui.nix;
        emacs = ./home/emacs.nix;
        kitty = ./home/kitty.nix;
        fonts = ./home/fonts.nix;
        dev = ./home/dev;
        hyprland = ./home/hyprland;
        hypridle = ./home/hypridle.nix;
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
        laptop = ./system/laptop.nix;
        nixGc = ./system/nix-gc.nix;
      };

      inherit (hostOutputs) nixosConfigurations homeConfigurations;
    };
}
