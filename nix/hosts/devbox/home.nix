{ self, ... }:

{
  imports = with self.homeModules; [
    common
    cli
    localBin
    dev
  ];
}
