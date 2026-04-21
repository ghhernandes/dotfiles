{
  self,
  pkgs,
  ...
}:

{
  imports = with self.systemModules; [
    ./hardware-configuration.nix
    audio
    security
  ];

  users.users.gh = {
    isNormalUser = true;
    description = "Gabriel";
    extraGroups = [
      "networkmanager"
      "wheel"
    ];
    shell = pkgs.zsh;
    linger = true;
  };

  networking = {
    hostName = "devbox";
    networkmanager.enable = true;
  };

  programs.zsh.enable = true;

  services = {
    printing.enable = true;

    tailscale.enable = true;

    openssh = {
      enable = true;
      settings = {
        PasswordAuthentication = true; # TODO: disable after ssh-copy-id
        PermitRootLogin = "no";
      };
    };
  };
}
