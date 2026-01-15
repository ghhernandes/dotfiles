{ config, pkgs, ... }:
{
  # Enable I2C for RGB control (Corsair RAM)
  hardware.i2c.enable = true;

  # OpenRGB for controlling RGB hardware
  services.hardware.openrgb = {
    enable = false;
    motherboard = "amd";
  };

  # Systemd service to disable Corsair RAM LEDs at boot
  systemd.services.corsair-ram-leds-off = {
    enable = false;
    description = "Disable Corsair RAM LEDs";
    after = [ "openrgb.service" ];
    wantedBy = [ "multi-user.target" ];
    serviceConfig = {
      Type = "oneshot";
      ExecStart = "${pkgs.openrgb}/bin/openrgb --device 0 --mode static --color 000000 --device 1 --mode static --color 000000";
      RemainAfterExit = true;
    };
  };
}

