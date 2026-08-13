{
  self,
  pkgs,
  lib,
  ...
}:

{
  imports = with self.systemModules; [
    ./hardware-configuration.nix
    audio
    bluetooth
    hyprland
    docker
    virtualization
    security
    packageManagers
    laptop
  ];

  boot = {
    loader.systemd-boot.enable = true;
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

  # A closed lid suspends and then hibernates after the delay, on battery and on
  # AC alike: plain suspend has no hibernate timer, so a machine suspended while
  # plugged in and later unplugged would drain in s2idle with no fallback.
  #
  # Docked is set explicitly because it defaults to "ignore" *and* applies
  # whenever more than one display is connected — leaving it would mean the lid
  # does nothing while an external monitor is plugged in.
  #
  # LidSwitchIgnoreInhibited defaults to "yes", meaning the lid ignores
  # high-level inhibitors; "no" makes it respect them, which is what lets
  # `caffeine` keep the machine awake through a lid close. Hyprland locks the
  # session separately on lid close, so it still locks when sleep is inhibited.
  services.logind.settings.Login = {
    HandleLidSwitch = lib.mkForce "suspend-then-hibernate";
    HandleLidSwitchExternalPower = lib.mkForce "suspend-then-hibernate";
    HandleLidSwitchDocked = lib.mkForce "suspend-then-hibernate";
    LidSwitchIgnoreInhibited = "no";
  };
  systemd.sleep.settings.Sleep.HibernateDelaySec = "30min";

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
      "docker"
    ];
    shell = pkgs.zsh;
  };

  networking.hostName = "zenbook-s14";
  networking.networkmanager.enable = true;

  programs.zsh.enable = true;

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
