You're running inside WSL NixOS.

Nix configuration files are at ~/.dotfiles/nix.

Run all nix commands from ~/.dotfiles/nix.

Update flake inputs: nix flake update

Rebuild the system: sudo nixos-rebuild switch --flake .#callisto

Switch home-manager: home-manager switch --flake .#callisto
