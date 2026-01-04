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

    systems.url = "github:nix-systems/default";
  };

  outputs = { self, nixpkgs, home-manager, lanzaboote, ...}@inputs:
  {
    homeModules = {
      common = ./home/common.nix;
      cli = ./home/cli.nix;
      tmux = ./home/tmux.nix;
      git = ./home/git.nix;
      neovim = ./home/neovim.nix;
      shell = ./home/shell.nix;
      emacs = ./home/emacs.nix;
      kitty = ./home/kitty.nix;
      editors = ./home/editors.nix;
      browsers = ./home/browsers.nix;
      media = ./home/media.nix;
      messaging = ./home/messaging.nix;
      passwordManager = ./home/password-manager.nix;
      claudeCode = ./home/claude-code.nix;
      dev = ./home/dev;
      hyprland = ./home/hyprland;
      rofi = ./home/rofi;
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
    };

    nixosConfigurations = (
      import ./hosts {
        inherit nixpkgs home-manager lanzaboote inputs;
        system = "x86_64-linux";
      }
    );

    homeConfigurations = (
      import ./profiles {
        inherit self nixpkgs home-manager;
        system = "x86_64-linux";
      }
    );
  };
}
