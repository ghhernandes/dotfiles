# NixOS configuration

This repository contains the Nix flake configuration for system and user management.


## NixOS System

```bash
# Syntax: sudo nixos-rebuild switch --flake .#<hostname>
nixos-rebuild switch --flake .#ghstation
```

## Non-NixOS System (Standalone)
```bash
# Syntax: home-manager switch --flake .#<username>
home-manager switch --flake .#gh
```
