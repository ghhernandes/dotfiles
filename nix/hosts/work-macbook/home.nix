{ self, ... }:

{
  imports = with self.homeModules; [
    common
    cli
  ];
}
