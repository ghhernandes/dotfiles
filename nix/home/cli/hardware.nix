{ pkgs, ... }:

{
  # Hardware-specific CLI/TUI tools. Only pulled in by profiles that
  # import `cliHardware` (currently: gh).
  home.packages = [
    pkgs.impala           # Wi-Fi TUI
    pkgs.bluetui          # Bluetooth TUI
    pkgs.yubikey-manager  # Yubikey CLI
  ];
}
