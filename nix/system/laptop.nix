{ pkgs, lib, ... }:

{
  services = {
    # Power profile switching (balanced/performance/power-saver), plus asusd
    # which extends it with ASUS-specific controls: battery charge limit,
    # keyboard backlight, and the laptop's Fn+F5 profile-cycle key.
    power-profiles-daemon.enable = true;
    asusd.enable = true;

    # Intel-specific thermal management.
    thermald.enable = true;

    # Firmware updates (BIOS/EC/etc) via LVFS.
    fwupd.enable = true;

    # Defaults; a host with hibernate configured (resumeDevice set) can raise
    # the on-battery action to suspend-then-hibernate.
    logind.settings.Login = {
      HandleLidSwitch = lib.mkDefault "suspend";
      HandleLidSwitchExternalPower = lib.mkDefault "suspend";
    };
  };

  systemd = {
    # asusd's unit runs ProtectSystem=strict with ReadWritePaths=/etc/asusd/,
    # so the directory must exist or systemd fails namespace setup (226) before
    # the daemon starts. The asusd module only creates it when given a config
    # file; with none set we create the empty dir here so asusd can populate it.
    tmpfiles.rules = [ "d /etc/asusd 0755 root root - -" ];

    # The asusctl package ships the asusd unit (Type=dbus, no [Install]) and a
    # D-Bus *policy* file, but no D-Bus *activation* file — so nothing starts it
    # at boot or on demand. Want it at boot so the LEDs, battery limit, and Fn
    # profile keys work.
    services.asusd.wantedBy = [ "multi-user.target" ];
  };

  environment.systemPackages = [
    pkgs.brightnessctl
    pkgs.powertop
  ];
}
