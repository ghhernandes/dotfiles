{
  self,
  pkgs,
  ...
}:

{
  imports = with self.systemModules; [
    ./hardware-configuration.nix
    audio
    bluetooth
    hyprland
    podman
    virtualization
    security
    packageManagers
    laptop
    nixGc
    containers
  ];

  boot = {
    loader.systemd-boot = {
      enable = true;
      configurationLimit = 10;
    };
    loader.efi.canTouchEfiVariables = true;
    kernelPackages = pkgs.linuxPackages_latest;

    # Swap partition's LUKS mapping. Root's mapping already lives in
    # hardware-configuration.nix (generated); nixos-generate-config doesn't
    # pick up the swap one, so it's carried over from /etc/nixos/configuration.nix.
    initrd.luks.devices."luks-ce024c4d-5d6e-4938-b7cc-900053b2d37d".device =
      "/dev/disk/by-uuid/ce024c4d-5d6e-4938-b7cc-900053b2d37d";

    # Hibernate resume target: the *decrypted* swap device. The initrd unlocks
    # the LUKS swap (above) before the resume step, so the image — written to
    # encrypted swap — is read back after unlock. UUID is the swap signature
    # inside the mapper, not the LUKS partition's.
    resumeDevice = "/dev/disk/by-uuid/6e438b3a-e057-4755-8d0c-a9236ce62932";
  };

  # A closed lid always suspends, and hibernates once the delay expires. The
  # three cases are spelled out because their defaults disagree: Docked is
  # "ignore" *and* applies whenever more than one display is connected, so
  # leaving it would mean the lid does nothing with an external monitor
  # attached. (laptop.nix sets the first two as mkDefault, so plain values win.)
  #
  # LidSwitchIgnoreInhibited defaults to "yes", meaning the lid ignores
  # high-level inhibitors; "no" makes it respect them, which is what lets
  # `caffeine` keep the machine awake through a lid close. Hyprland locks the
  # session separately on lid close, so it still locks when sleep is inhibited.
  services.logind.settings.Login = {
    HandleLidSwitch = "suspend-then-hibernate";
    HandleLidSwitchExternalPower = "suspend-then-hibernate";
    HandleLidSwitchDocked = "suspend-then-hibernate";
    LidSwitchIgnoreInhibited = "no";
  };

  # On AC the machine stays in s2idle indefinitely and the countdown starts
  # only once power is pulled, so being plugged in keeps fast resume without
  # giving up the hibernate fallback for a laptop that gets unplugged while
  # asleep. Independently of the timer, the battery's ACPI trip point can
  # trigger hibernation early if the charge runs low first.
  systemd.sleep.settings.Sleep = {
    HibernateDelaySec = "30min";
    HibernateOnACPower = "no";
  };

  hardware.cpu.intel.updateMicrocode = true;
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
    extraPackages = [
      pkgs.intel-media-driver
      pkgs.vpl-gpu-rt
    ];
  };

  users.users.gh = {
    isNormalUser = true;
    description = "Gabriel";
    extraGroups = [
      "networkmanager"
      "wheel"
    ];
    shell = pkgs.zsh;
  };

  networking.hostName = "zenbook-s14";
  networking.networkmanager.enable = true;

  programs.zsh.enable = true;

  services.tailscale.enable = true;

  containerServices.pihole.enable = true;

  # The keyboard backlight LED resets to 0 on boot. Restore it to low (1 of 3)
  # each boot; the Fn keys (wired in home/hyprland) still adjust it live.
  systemd.services.kbd-backlight-default = {
    description = "Default keyboard backlight to low at boot";
    wantedBy = [ "multi-user.target" ];
    after = [ "systemd-udevd.service" ];
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
      ExecStart = "${pkgs.brightnessctl}/bin/brightnessctl -d asus::kbd_backlight set 1";
    };
  };
}
