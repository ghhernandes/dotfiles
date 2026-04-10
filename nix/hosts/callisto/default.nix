{ self, config, pkgs, lib, inputs, ... }:

{
  imports = (with self.systemModules; [
    security
    docker
  ]) ++ [
    inputs.nixos-wsl.nixosModules.default
  ];

  # --- NixOS-WSL configuration ---
  wsl = {
    enable = true;
    defaultUser = "gh";
    startMenuLaunchers = false;

    # NixOS-WSL manages /etc/wsl.conf declaratively.
    wslConf = {
      network.hostname = "callisto";
      # Keep Windows PATH interop on so code.exe, clip.exe, etc. work.
      interop.appendWindowsPath = true;
    };
  };

  # --- Identity ---
  networking.hostName = "callisto";

  users.users.gh = {
    isNormalUser = true;
    description = "Gabriel";
    extraGroups = [ "wheel" ]; # docker group is added by system/docker.nix
    shell = pkgs.zsh;
  };

  programs.zsh.enable = true;

  # No hardware-configuration.nix, no bootloader, no filesystems:
  # NixOS-WSL supplies all of that.
}
