# dotfiles

NixOS and home-manager configurations using flakes.

## Structure

```
nix/
├── flake.nix           # Main entry point, exports modules
├── system/             # System-level modules (audio, bluetooth, gaming, etc.)
├── home/               # Home-manager modules (browsers, editors, shell, etc.)
├── hosts/              # Host configurations (per-machine settings)
└── profiles/           # User profiles (imports home modules)
```

## System Modules

System modules configure NixOS system-level features like hardware, services, and system-wide settings. Located in `nix/system/`.

Each host imports only the system modules it needs, making configurations modular and reusable across machines.

## Home Modules

Home modules configure user environment and applications that don't require root privileges. Located in `nix/home/`.

Each profile imports only the home modules it needs, allowing different users or setups to share common configurations while customizing their environment.

## Usage

Build NixOS system:
```bash
cd nix
sudo nixos-rebuild switch --flake .#ghstation
```

Build home-manager:
```bash
cd nix
home-manager switch --flake .#gh
```
