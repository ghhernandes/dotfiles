{ config, lib, ... }:

{
  config = lib.mkIf config.containerServices.pihole.enable {
    # Unlike docker, podman doesn't auto-create missing bind-mount host
    # directories — it fails with "statfs ...: no such file or directory".
    systemd.tmpfiles.rules = [
      "d /var/lib/pihole/etc-pihole 0755 root root - -"
      "d /var/lib/pihole/etc-dnsmasq.d 0755 root root - -"
    ];

    virtualisation.oci-containers.containers.pihole = {
      # Pinned release tag — never `latest` for a network-facing service;
      # check hub.docker.com/r/pihole/pihole/tags before bumping.
      image = "pihole/pihole:2026.07.2";
      extraOptions = [ "--network=host" ];
      environment = {
        TZ = "America/Sao_Paulo";
        # Plain text: accepted risk, exposure limited to the tailnet (see
        # firewall rule below) and this is a trusted single-user machine.
        # WEBPASSWORD is a v5-era name; v6 uses the FTLCONF_ equivalent.
        FTLCONF_webserver_api_password = "1234";
        # 8080 instead of the default 80, to leave port 80 free for other
        # services on this host. "o" = don't fail startup if the port's taken.
        FTLCONF_webserver_port = "8080o,443os,[::]:8080o,[::]:443os";
      }
      # Pihole itself only speaks plain DNS upstream; route through the
      # dnscrypt-proxy sidecar (127.0.0.1, since both are --network=host)
      # for actual DoH to Cloudflare when it's enabled.
      // lib.optionalAttrs config.containerServices.dnscryptProxy.enable {
        FTLCONF_dns_upstreams = "127.0.0.1#5053";
      };
      volumes = [
        "/var/lib/pihole/etc-pihole:/etc/pihole"
        "/var/lib/pihole/etc-dnsmasq.d:/etc/dnsmasq.d"
      ];
    };

    systemd.services.podman-pihole = lib.mkIf config.containerServices.dnscryptProxy.enable {
      after = [ "podman-dnscrypt-proxy.service" ];
      wants = [ "podman-dnscrypt-proxy.service" ];
    };

    # Scoped to the tailnet only — global allowedTCPPorts/allowedUDPPorts
    # would open DNS + the cleartext admin login on every network this
    # laptop joins (home, coffee shop, ...), not just trusted devices.
    networking.firewall.interfaces.tailscale0 = {
      allowedTCPPorts = [
        53
        8080
      ];
      allowedUDPPorts = [ 53 ];
    };
  };
}
