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

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.kernelPackages = pkgs.linuxPackages_latest;

  # Swap partition's LUKS mapping. Root's mapping already lives in
  # hardware-configuration.nix (generated); nixos-generate-config doesn't
  # pick up the swap one, so it's carried over from /etc/nixos/configuration.nix.
  boot.initrd.luks.devices."luks-ce024c4d-5d6e-4938-b7cc-900053b2d37d".device =
    "/dev/disk/by-uuid/ce024c4d-5d6e-4938-b7cc-900053b2d37d";

  # Hibernate resume target: the *decrypted* swap device. The initrd unlocks
  # the LUKS swap (above) before the resume step, so the image — written to
  # encrypted swap — is read back after unlock. UUID is the swap signature
  # inside the mapper, not the LUKS partition's.
  boot.resumeDevice = "/dev/disk/by-uuid/6e438b3a-e057-4755-8d0c-a9236ce62932";

  # A closed lid suspends to RAM and then hibernates after the delay, on both
  # battery and AC. Doing it on AC too closes a gap: plain suspend has no
  # hibernate timer, so a machine suspended while plugged in and then unplugged
  # would drain in s2idle with no fallback. suspend-then-hibernate always ends
  # up safely hibernated regardless of when the charger comes and goes.
  services.logind.settings.Login = {
    HandleLidSwitch = lib.mkForce "suspend-then-hibernate";
    HandleLidSwitchExternalPower = lib.mkForce "suspend-then-hibernate";
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
