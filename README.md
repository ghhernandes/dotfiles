# dotfiles

Build NixOS system:
```bash
cd nix
sudo nixos-rebuild switch --flake .#<host>
# Example: sudo nixos-rebuild switch --flake .#ghstation
```

Build home-manager:
```bash
cd nix
home-manager switch --flake .#<user>
# Example: home-manager switch --flake .#gh
```

Update flake:
```bash
cd nix
nix flake update
```
