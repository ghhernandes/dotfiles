# dotfiles

Rebuild system:
```bash
nixos-rebuild switch --flake .#ghstation
```

Rebuild home-manager (standalone):
```bash
home-manager switch --flake .#gh
```
