# dotfiles

NixOS + home-manager flake-based configurations for multiple hosts.

## Structure

```
ai/            # AI tool configs (Claude Code, future siblings), see ai/README.md
nix/
├── flake.nix     # Inputs, exports homeModules/systemModules, wires hosts
├── system/       # NixOS system modules (audio, docker, hyprland, ...)
├── home/         # home-manager modules (cli, gui, dev, ai, hyprland, ...)
└── hosts/        # Per-host configs; each subdir auto-discovered
    ├── configuration.nix   # Shared base system config
    ├── callisto/           # WSL dev environment
    ├── ghstation/          # Hyprland desktop / gaming workstation
    └── devbox/             # Minimal GNOME dev box
```

## Hosts

- **callisto** — NixOS-WSL, CLI + dev + reverse-engineering
- **ghstation** — Full Hyprland desktop, gaming, virtualization, secure boot
- **devbox** — Minimal GNOME dev box

## Modules

`flake.nix` exports two attribute sets — `systemModules` and `homeModules` —
that hosts pick from. Each host's `default.nix` imports the system modules it
needs, and (if present) its `home.nix` imports the home modules it needs.

New hosts are picked up automatically by `hosts/default.nix`: any subdirectory
becomes a `nixosConfiguration`, and if it also contains a `home.nix` it
becomes a `homeConfiguration` keyed by the host name (default user `gh`).

## Usage

```bash
cd nix

# System rebuild (pick the active host)
sudo nixos-rebuild switch --flake .#callisto
sudo nixos-rebuild switch --flake .#ghstation
sudo nixos-rebuild switch --flake .#devbox

# Home-manager (keyed by host, not user)
home-manager switch --flake .#callisto

# Update flake inputs
nix flake update
```
