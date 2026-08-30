{ pkgs, ... }:

# Desktop helper scripts packaged as proper Nix apps: each declares its
# runtime dependencies explicitly (so they're guaranteed on PATH regardless
# of the caller's environment) and is shellcheck-linted at build time.
let
  mkScript =
    name: runtimeInputs:
    pkgs.writeShellApplication {
      inherit name runtimeInputs;
      text = builtins.readFile (./scripts + "/${name}.sh");
    };
in
{
  home.packages = [
    (mkScript "keybinds" [
      pkgs.hyprland
      pkgs.jq
      pkgs.util-linux
    ])
  ];
}
