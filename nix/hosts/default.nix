{
  self,
  nixpkgs,
  home-manager,
  lanzaboote,
  claude-code,
  inputs,
  ...
}:

let
  inherit (nixpkgs) lib;

  hostDirs = builtins.readDir ./.;
  isDirectory = _name: type: type == "directory";
  hosts = lib.filterAttrs isDirectory hostDirs;

  defaultMeta = {
    system = "x86_64-linux";
    username = "gh";
  };

  getHostMeta =
    name:
    let
      metaPath = ./. + "/${name}/meta.nix";
    in
    if builtins.pathExists metaPath then defaultMeta // (import metaPath) else defaultMeta;

  homePrefix = system: if lib.hasSuffix "-darwin" system then "/Users" else "/home";

  # Only build NixOS configs for hosts that have a system-level default.nix
  hasSystem = name: builtins.pathExists (./. + "/${name}/default.nix");

  mkSystem =
    name: _:
    let
      meta = getHostMeta name;
    in
    lib.nixosSystem {
      system = meta.system;
      specialArgs = { inherit self lanzaboote inputs; };
      modules = [
        ./configuration.nix
        ./${name}
      ];
    };

  hasHome = name: builtins.pathExists (./. + "/${name}/home.nix");

  mkHome =
    name: _:
    let
      meta = getHostMeta name;
    in
    home-manager.lib.homeManagerConfiguration {
      pkgs = nixpkgs.legacyPackages.${meta.system};
      extraSpecialArgs = {
        inherit self;
        hostName = name;
        dotfilesPath = self + "/..";
      };
      modules = [
        (./. + "/${name}/home.nix")
        {
          nixpkgs.overlays = [
            claude-code.overlays.default
          ];
          home.username = lib.mkDefault meta.username;
          home.homeDirectory = lib.mkDefault "${homePrefix meta.system}/${meta.username}";
        }
      ];
    };

  hostsWithSystem = lib.filterAttrs (name: _: hasSystem name) hosts;
  hostsWithHome = lib.filterAttrs (name: _: hasHome name) hosts;
in
{
  nixosConfigurations = lib.mapAttrs mkSystem hostsWithSystem;
  homeConfigurations = lib.mapAttrs mkHome hostsWithHome;
}
