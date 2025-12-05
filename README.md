# dotfiles

This repository contains NixOS and application configurations.

Main flake configuration lives in the nix directory. Entry point is flake.nix which defines system and user configurations.

System configurations are organized in the hosts directory. Each host has its own directory. Shared system settings live in configuration.nix.

User environment configurations are in the home-manager directory. Shared user settings are in common.nix. User-specific configurations go in the profiles directory. Reusable configuration modules are in the modules directory.

Traditional application dotfiles are in the root directory.

Build NixOS system:
```bash
cd nix
sudo nixos-rebuild switch --flake .#<host>
```

Build home-manager:
```bash
cd nix
home-manager switch --flake .#<user>
```
