{
  self,
  lib,
  pkgs,
  ...
}:

{
  imports = with self.systemModules; [
    ./hardware-configuration.nix
    audio
    bluetooth
    plasma
    podman
    virtualization
    security
    packageManagers
    ollama
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

  # A closed lid always suspends when undocked, and hibernates once the delay
  # expires. Docked (systemd's own definition: more than one display
  # connected) is left at "ignore" so closing the lid with the external
  # monitor attached keeps the machine running instead of sleeping. Plasma's
  # PowerDevil enforces the same policy while a session runs
  # (home/plasma); these settings cover the login screen. (laptop.nix sets
  # the first two as mkDefault, so plain values win.)
  #
  # LidSwitchIgnoreInhibited defaults to "yes", meaning the lid ignores
  # high-level inhibitors; "no" makes it respect them, so a sleep-blocking
  # inhibitor (Plasma's "block sleep" toggle) keeps the machine awake through
  # a lid close.
  services.logind.settings.Login = {
    HandleLidSwitch = "suspend-then-hibernate";
    HandleLidSwitchExternalPower = "suspend-then-hibernate";
    HandleLidSwitchDocked = "ignore";
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

  # CPU-only: the iGPU has no well-supported Ollama acceleration backend
  # here, and the tiny default model (nix/system/ollama.nix) is small enough
  # that CPU inference stays usable.
  ai.ollama.enable = true;

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

  # Plasma ships Bluedevil; Blueman would add a second tray applet.
  services.blueman.enable = lib.mkForce false;

  services.tailscale.enable = true;

  containerServices.pihole.enable = true;
  containerServices.dnscryptProxy.enable = true;

  # The keyboard backlight LED resets to 0 on boot. Restore it to low (1 of 3)
  # each boot; the Fn keys (handled by PowerDevil) still adjust it live.
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
