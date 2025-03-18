{ inputs, ... }:
{
  imports = [
    inputs.flake-parts.flakeModules.modules
    ./treefmt.nix
    ./dev-shell.nix
    ./packages.nix
  ];
}
