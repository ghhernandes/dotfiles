{ nixpkgs, home-manager, lanzaboote, inputs, system, ... }:

let
  lib = nixpkgs.lib;
in
{
  ghstation = lib.nixosSystem {
    inherit system;

    modules = [
      ./configuration.nix
      ./ghstation

      lanzaboote.nixosModules.lanzaboote

      home-manager.nixosModules.home-manager

      {
        home-manager.useGlobalPkgs = true;
        home-manager.useUserPackages = true;

        home-manager.users.gh = import ./ghstation/home.nix;
        home-manager.extraSpecialArgs = { inherit inputs system; };
      }
    ];
  };
}
