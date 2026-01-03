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
    ];
  };
}
