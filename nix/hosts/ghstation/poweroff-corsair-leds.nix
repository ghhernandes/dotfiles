{ config, pkgs, ... }:

{
  # OpenRGB for controlling Corsair RAM LEDs
  services.hardware.openrgb = {
    enable = true;
    motherboard = "amd";
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
