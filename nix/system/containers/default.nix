{ lib, ... }:

{
  imports = [
    ./pihole.nix
    ./dnscrypt-proxy.nix
  ];

  options.containerServices = {
    pihole.enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Run pihole as a container.";
    };
    dnscryptProxy.enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Run dnscrypt-proxy as pihole's DNS-over-HTTPS upstream sidecar.";
    };
  };

  config.virtualisation.oci-containers.backend = "podman";
}
