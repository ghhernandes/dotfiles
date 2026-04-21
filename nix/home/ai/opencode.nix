{
  config,
  pkgs,
  lib,
  dotfilesPath,
  hostName,
  ...
}:

let
  opencodeRepo = dotfilesPath + "/ai/opencode";
  hostRepo = opencodeRepo + "/hosts/${hostName}";

  jsonFormat = pkgs.formats.json { };

  # ---- opencode.json: shared base + optional per-host override ----
  baseConfig =
    if builtins.pathExists (opencodeRepo + "/opencode.json") then
      builtins.fromJSON (builtins.readFile (opencodeRepo + "/opencode.json"))
    else
      { };
  hostConfigPath = hostRepo + "/opencode.json";
  hostConfig =
    if builtins.pathExists hostConfigPath then
      builtins.fromJSON (builtins.readFile hostConfigPath)
    else
      { };
  mergedConfig = lib.recursiveUpdate baseConfig hostConfig;
  configFile = jsonFormat.generate "opencode.json" mergedConfig;

  # ---- tui.json: shared base + optional per-host override ----
  baseTui =
    if builtins.pathExists (opencodeRepo + "/tui.json") then
      builtins.fromJSON (builtins.readFile (opencodeRepo + "/tui.json"))
    else
      { };
  hostTuiPath = hostRepo + "/tui.json";
  hostTui =
    if builtins.pathExists hostTuiPath then builtins.fromJSON (builtins.readFile hostTuiPath) else { };
  mergedTui = lib.recursiveUpdate baseTui hostTui;
  tuiFile = jsonFormat.generate "tui.json" mergedTui;
in
{
  home.packages = [ pkgs.opencode ];

  xdg.configFile = {
    "opencode/opencode.json".source = configFile;
    "opencode/tui.json".source = tuiFile;
  };
}
