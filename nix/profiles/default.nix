{ self, nixpkgs, home-manager, system, ... }:

let
  lib = nixpkgs.lib;

  profileDirs = builtins.readDir ./.;

  isDirectory = name: type: type == "directory";
  profiles = lib.filterAttrs isDirectory profileDirs;

  homePrefix = if lib.hasSuffix "-darwin" system then "/Users" else "/home";

  mkProfile = username: _:
    home-manager.lib.homeManagerConfiguration {
      pkgs = nixpkgs.legacyPackages.${system};
      extraSpecialArgs = { inherit self; };
      modules = [
        ./${username}
        {
          home.username = lib.mkForce username;
          home.homeDirectory = lib.mkForce "${homePrefix}/${username}";
        }
      ];
    };
in
  lib.mapAttrs mkProfile profiles
