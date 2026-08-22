{ lib, ... }:

{
  imports = [ ./pihole.nix ];

  options.containerServices = {
    pihole.enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Run pihole as a container.";
    };
  };

  config.virtualisation.oci-containers.backend = "podman";
}
