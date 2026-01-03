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
  let
    mkHome = { system, profile }:
      home-manager.lib.homeManagerConfiguration {
        pkgs = nixpkgs.legacyPackages.${system};
        modules = [ profile ];
      };
  in
  {
    nixosConfigurations = (
      import ./hosts {
        inherit nixpkgs home-manager lanzaboote inputs;
        system = "x86_64-linux";
      }
    );

    homeConfigurations = {
      "gh" = mkHome {
        system = "x86_64-linux";
        profile = ./home/profiles/personal.nix;
      };
    };
  };
}
