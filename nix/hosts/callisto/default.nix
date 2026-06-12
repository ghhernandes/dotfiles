{
  self,
  pkgs,
  inputs,
  ...
}:

{
  imports =
    (with self.systemModules; [
      security
      docker
    ])
    ++ [
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
    openssh.authorizedKeys.keys = [
      # Windows host (ghh.hernandes@gmail.com)
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILRC8Q7D5dCZta43eA0QhYhA23X9n+Uq8f72L3wI6tnp ghh.hernandes@gmail.com"
    ];
  };

  programs.zsh.enable = true;

  services.tailscale.enable = true;

  services.openssh = {
    enable = true;
    settings = {
      PasswordAuthentication = true; # TODO: disable after ssh-copy-id
      PermitRootLogin = "no";
    };
  };

  # No hardware-configuration.nix, no bootloader, no filesystems:
  # NixOS-WSL supplies all of that.
}
