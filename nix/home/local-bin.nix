{ config, pkgs, lib, dotfilesPath, ... }:

let
  # Use the dotfilesPath passed from flake.nix
  localBinPath = "${dotfilesPath}/local-bin";

  # Read all files in local-bin directory
  localBinFiles = builtins.readDir (dotfilesPath + "/local-bin");

  # Filter to only include regular files (not directories)
  scriptFiles = lib.filterAttrs (name: type: type == "regular") localBinFiles;

  # Create a symlink entry for each script
  mkScriptLink = name: _: {
    name = ".local/bin/${name}";
    value = {
      source = config.lib.file.mkOutOfStoreSymlink "${localBinPath}/${name}";
    };
  };

  # Generate all symlinks
  scriptLinks = lib.mapAttrs' mkScriptLink scriptFiles;
in
{
  # Automatically symlink all scripts from local-bin to ~/.local/bin
  home.file = scriptLinks;
}
