{ nixpkgs, home-manager, ... }:

let
  system = "x86_64-linux";
  lib = nixpkgs.lib;
in
{
  ghstation = lib.nixosSystem {
    inherit system;

    modules = [
      ./configuration.nix
      ./ghstation

      home-manager.nixosModules.home-manager

      {
        home-manager.useGlobalPkgs = true;
        home-manager.useUserPackages = true;

        home-manager.users.gh = import ./ghstation/home.nix;
      }
    ];
  };
}
