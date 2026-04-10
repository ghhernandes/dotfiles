{ self, ... }:

{
  imports = with self.homeModules; [
    common
    cli
    dev
    reverseEngineering
    ai
  ];

  # SSH: callisto uses gcr-ssh-agent (GNOME Keyring) as its SSH agent.
  # The agent is already running with the GitHub key unlocked, but shells
  # don't reliably export SSH_AUTH_SOCK into every context (Claude Code's
  # non-interactive shell in particular). Setting `IdentityAgent` at the
  # ssh_config level makes git/ssh find the socket regardless of env.
  # Other hosts use a different agent and configure it in their own home.nix.
  programs.ssh = {
    enable = true;
    # home-manager 25.11 is deprecating the implicit "Host *" defaults it
    # writes into ssh_config. Every one of those defaults already matches
    # OpenSSH's own defaults, so opting out here silences the deprecation
    # warning and loses nothing at runtime.
    enableDefaultConfig = false;
    matchBlocks."*".identityAgent = "/run/user/1000/gcr/ssh";
  };
}
