{ nixpkgs, home-manager, lanzaboote, inputs, system, ... }:

let
  lib = nixpkgs.lib;

  hostDirs = builtins.readDir ./.;
  isDirectory = name: type: type == "directory";
  hosts = lib.filterAttrs isDirectory hostDirs;

  mkHost = name: _: lib.nixosSystem {
    inherit system;

    modules = [
      ./configuration.nix
      ./${name}

      lanzaboote.nixosModules.lanzaboote
    ];
  };
in
  lib.mapAttrs mkHost hosts
