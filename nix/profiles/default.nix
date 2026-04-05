{ self, nixpkgs, home-manager, system, claude-code, ... }:

let
  lib = nixpkgs.lib;

  profileDirs = builtins.readDir ./.;

  isDirectory = name: type: type == "directory";
  profiles = lib.filterAttrs isDirectory profileDirs;

  homePrefix = if lib.hasSuffix "-darwin" system then "/Users" else "/home";

  mkProfile = username: _:
    home-manager.lib.homeManagerConfiguration {
      pkgs = nixpkgs.legacyPackages.${system};
      extraSpecialArgs = {
        inherit self;
        dotfilesPath = self + "/..";
      };
      modules = [
        ./${username}
        {
          nixpkgs.overlays = [ claude-code.overlays.default ];

          home.username = lib.mkDefault username;
          home.homeDirectory = lib.mkDefault "${homePrefix}/${username}";
        }
      ];
    };
in
  lib.mapAttrs mkProfile profiles
