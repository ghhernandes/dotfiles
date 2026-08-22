_:

{
  # Enable the gnome-keyring secrets vault.
  # Will be exposed through DBus to programs willing to store secrets.
  services.gnome.gnome-keyring.enable = true;

  # Plain `environment.systemPackages` installs the binaries but not the
  # setuid browser-support helper + polkit policy the CLI needs to talk to
  # the desktop app (`op` would fail with "connecting to desktop app: read:
  # connection reset" and no socket under ~/.1password/) — these dedicated
  # modules wire that up.
  programs._1password.enable = true;
  programs._1password-gui = {
    enable = true;
    polkitPolicyOwners = [ "gh" ];
  };
}
