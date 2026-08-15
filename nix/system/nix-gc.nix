_:

{
  nix.optimise.automatic = true;

  # `nh clean all` prunes generations across every profile it finds — system,
  # home-manager, per-user — and then GCs the store itself, so it replaces
  # nix.gc rather than complementing it. Running both concurrently walks and
  # collects the store twice and races on the store lock; the nixpkgs module
  # warns about exactly that combination.
  programs.nh = {
    enable = true;
    clean = {
      enable = true;
      extraArgs = "--keep-since 30d --keep 5";
    };
  };
}
