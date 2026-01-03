{ config, pkgs, ... }:
{
  services.prometheus.exporters.node = {
    enable = true;
    port = 9000;
  };

  # OpenRGB for controlling Corsair RAM LEDs
  services.hardware.openrgb = {
    enable = true;
    motherboard = "amd";
  };

  services.sunshine = {
    enable = true;
    autoStart = true;
    capSysAdmin = true;
    openFirewall = true;
  };

  networking.firewall = {
    enable = true;
    allowedTCPPorts = [ 47984 47989 47990 48010 ];
    allowedUDPPortRanges = [
      { from = 47998; to = 48000; }
      { from = 8000; to = 8010; }
    ];
  };

  # Systemd service to disable Corsair RAM LEDs at boot
  systemd.services.corsair-ram-leds-off = {
    description = "Disable Corsair RAM LEDs";
    after = [ "openrgb.service" ];
    wantedBy = [ "multi-user.target" ];
    serviceConfig = {
      Type = "oneshot";
      ExecStart = "${pkgs.openrgb}/bin/openrgb --device 0 --mode static --color 000000 --device 1 --mode static --color 000000";
      RemainAfterExit = true;
    };
  };

  environment.systemPackages = with pkgs; [
    openrgb
  ];

}
