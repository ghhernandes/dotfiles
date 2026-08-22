{
  config,
  pkgs,
  lib,
  dotfilesPath,
  ...
}:

let
  opencodeRepo = dotfilesPath + "/ai/opencode";
in
{
  config = lib.mkIf config.ai.opencode.enable {
    home.packages = [ pkgs.opencode ];

    xdg.configFile = {
      "opencode/opencode.json".source = opencodeRepo + "/opencode.json";
      "opencode/tui.json".source = opencodeRepo + "/tui.json";
    };
  };
}
