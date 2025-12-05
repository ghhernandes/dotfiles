{
  description = "ghhernandes NixOS configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.11";

    home-manager.url = "github:nix-community/home-manager/release-25.11";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    systems.url = "github:nix-systems/default";
  };

  outputs = { self, nixpkgs, home-manager, ...}@inputs:
  let
    # Helper function to create home-manager configuration
    mkHome = { system, profile }:
      home-manager.lib.homeManagerConfiguration {
        pkgs = nixpkgs.legacyPackages.${system};
        modules = [ profile ];
      };
  in
  {
    # NixOS configurations remain outside eachSystem (Linux-only)
    nixosConfigurations = (
      import ./hosts {
        inherit nixpkgs home-manager inputs;
        system = "x86_64-linux";
      }
    );

    # Home-manager standalone configurations for multiple systems
    homeConfigurations = {
      # Linux configuration with personal profile
      "gh" = mkHome {
        system = "x86_64-linux";
        profile = ./home-manager/profiles/personal.nix;
      };
    };
  };
}
