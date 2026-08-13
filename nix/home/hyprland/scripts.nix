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
    (mkScript "screenshot" [
      pkgs.grim
      pkgs.slurp
      pkgs.wl-clipboard
      pkgs.jq
      pkgs.hyprland
      pkgs.coreutils
    ])
    (mkScript "keybinds" [
      pkgs.hyprland
      pkgs.jq
      pkgs.util-linux
    ])
    (mkScript "rofi-power" [
      pkgs.rofi
      pkgs.systemd
      pkgs.hyprlock
      pkgs.coreutils
    ])
    (mkScript "focus-mode" [
      pkgs.dunst
      pkgs.libnotify
      pkgs.coreutils
    ])
    (mkScript "caffeine" [
      pkgs.systemd
      pkgs.procps
      pkgs.libnotify
      pkgs.coreutils
      pkgs.gnugrep
      pkgs.rofi
    ])
  ];
}
