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
  };

  networking = {
    hostName = "devbox";
    networkmanager.enable = true;
  };

  programs.zsh.enable = true;

  services = {
    # GNOME Desktop
    xserver = {
      enable = true;
      displayManager.gdm.enable = true;
      desktopManager.gnome.enable = true;
      videoDrivers = [
        "modesetting"
        "fbdev"
      ];
      xkb = {
        layout = "us";
        variant = "";
      };
    };
    printing.enable = true;
  };
}
