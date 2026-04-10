{ self, nixpkgs, home-manager, lanzaboote, claude-code, inputs, system, ... }:

let
  lib = nixpkgs.lib;

  hostDirs = builtins.readDir ./.;
  isDirectory = name: type: type == "directory";
  hosts = lib.filterAttrs isDirectory hostDirs;

  homePrefix = if lib.hasSuffix "-darwin" system then "/Users" else "/home";

  mkSystem = name: _: lib.nixosSystem {
    inherit system;
    specialArgs = { inherit self lanzaboote inputs; };
    modules = [
      ./configuration.nix
      ./${name}
    ];
  };

  hasHome = name: builtins.pathExists (./. + "/${name}/home.nix");

  mkHome = name: _:
    home-manager.lib.homeManagerConfiguration {
      pkgs = nixpkgs.legacyPackages.${system};
      extraSpecialArgs = {
        inherit self;
        hostName = name;
        dotfilesPath = self + "/..";
      };
      modules = [
        (./. + "/${name}/home.nix")
        {
          nixpkgs.overlays = [ claude-code.overlays.default ];
          home.username = lib.mkDefault "gh";
          home.homeDirectory = lib.mkDefault "${homePrefix}/gh";
        }
      ];
    };

  hostsWithHome = lib.filterAttrs (name: _: hasHome name) hosts;
in
{
  nixosConfigurations = lib.mapAttrs mkSystem hosts;
  homeConfigurations  = lib.mapAttrs mkHome hostsWithHome;
}
