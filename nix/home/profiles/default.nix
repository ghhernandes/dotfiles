{ nixpkgs, home-manager, system, ... }:

let
  lib = nixpkgs.lib;

  # Read all entries in the profiles directory
  profileDirs = builtins.readDir ./.;

  # Filter to only include directories (excluding default.nix)
  isDirectory = name: type: type == "directory";
  profiles = lib.filterAttrs isDirectory profileDirs;

  # Determine home directory based on system
  homePrefix = if lib.hasSuffix "-darwin" system then "/Users" else "/home";

  # Create a home-manager configuration for each profile directory
  mkProfile = username: _:
    home-manager.lib.homeManagerConfiguration {
      pkgs = nixpkgs.legacyPackages.${system};
      modules = [
        ./${username}
        {
          home.username = lib.mkForce username;
          home.homeDirectory = lib.mkForce "${homePrefix}/${username}";
        }
      ];
    };
in
  # Generate an attribute set with all profile configurations
  lib.mapAttrs mkProfile profiles
