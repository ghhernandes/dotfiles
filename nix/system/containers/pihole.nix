{ config, lib, ... }:

{
  config = lib.mkIf config.containerServices.pihole.enable {
    virtualisation.oci-containers.containers.pihole = {
      # Pinned release tag — never `latest` for a network-facing service;
      # check hub.docker.com/r/pihole/pihole/tags before bumping.
      image = "pihole/pihole:2026.07.2";
      extraOptions = [ "--network=host" ];
      environment = {
        TZ = "America/Sao_Paulo";
        # Plain text: accepted risk, exposure limited to the tailnet (see
        # firewall rule below) and this is a trusted single-user machine.
        WEBPASSWORD = "1234";
      };
      volumes = [
        "/var/lib/pihole/etc-pihole:/etc/pihole"
        "/var/lib/pihole/etc-dnsmasq.d:/etc/dnsmasq.d"
      ];
    };

    # Scoped to the tailnet only — global allowedTCPPorts/allowedUDPPorts
    # would open DNS + the cleartext admin login on every network this
    # laptop joins (home, coffee shop, ...), not just trusted devices.
    networking.firewall.interfaces.tailscale0 = {
      allowedTCPPorts = [
        53
        80
      ];
      allowedUDPPorts = [ 53 ];
    };
  };
}
