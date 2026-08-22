{
  config,
  pkgs,
  lib,
  ...
}:

let
  # Sidecar for pihole's upstream queries: pihole itself only speaks plain
  # DNS to upstreams, so this handles the actual DoH connection to Cloudflare.
  # Bound to 127.0.0.1 only — nothing outside this host needs to reach it,
  # pihole (also on --network=host) talks to it over loopback.
  configFile = pkgs.writeText "dnscrypt-proxy.toml" ''
    listen_addresses = ['127.0.0.1:5053']
    server_names = ['cloudflare']

    ipv4_servers = true
    ipv6_servers = false
    dnscrypt_servers = true
    doh_servers = true
    odoh_servers = false

    require_dnssec = false

    force_tcp = false
    timeout = 5000

    bootstrap_resolvers = ['9.9.9.9:53', '8.8.8.8:53']
    ignore_system_dns = true
    netprobe_timeout = 60
    netprobe_address = '9.9.9.9:53'

    [sources.public-resolvers]
    urls = [
      'https://raw.githubusercontent.com/DNSCrypt/dnscrypt-resolvers/master/v3/public-resolvers.md',
      'https://download.dnscrypt.info/resolvers-list/v3/public-resolvers.md',
      'https://cdn.jsdelivr.net/gh/DNSCrypt/dnscrypt-resolvers@master/v3/public-resolvers.md'
    ]
    cache_file = '/var/cache/dnscrypt-proxy/public-resolvers.md'
    minisign_key = 'RWQf6LRCGA9i53mlYecO4IzT51TGPpvWucNSCh1CBM0QTaLn73Y7GFO3'
    refresh_delay = 73
  '';
in
{
  config = lib.mkIf config.containerServices.dnscryptProxy.enable {
    systemd.tmpfiles.rules = [
      "d /var/lib/dnscrypt-proxy/cache 0755 root root - -"
    ];

    virtualisation.oci-containers.containers.dnscrypt-proxy = {
      # No semver tags upstream, only floating branch/commit tags — pinned
      # by digest instead (what `main` currently resolves to).
      image = "klutchell/dnscrypt-proxy@sha256:ffbd0527b35af86e140f0cdfe5d0bb4a5182e47630bf25eea89bf61c22b61864";
      extraOptions = [ "--network=host" ];
      volumes = [
        "${configFile}:/config/dnscrypt-proxy.toml:ro"
        "/var/lib/dnscrypt-proxy/cache:/var/cache/dnscrypt-proxy"
      ];
    };
  };
}
