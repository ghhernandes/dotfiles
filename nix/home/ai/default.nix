{ lib, ... }:

{
  imports = [
    ./claude.nix
    ./opencode.nix
  ];

  options.ai = {
    claude.enable = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Install and configure Claude Code.";
    };
    opencode.enable = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Install and configure opencode.";
    };
  };
}
