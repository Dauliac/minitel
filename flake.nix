{
  description = "Minitel driven with esp32 micropython and nix";
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    treefmt-nix.url = "github:numtide/treefmt-nix";
    flake-parts.url = "github:hercules-ci/flake-parts";
    minitel-esp32 = {
      url = "github:iodeo/Minitel-ESP32";
      flake = false;
    };
  };
  outputs =
    inputs@{ flake-parts, ... }:
    flake-parts.lib.mkFlake { inherit inputs; } (_: {
      debug = true;
      systems = [
        "x86_64-linux"
      ];
      imports = [
        ./nix
      ];
    });
}
