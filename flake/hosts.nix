{ inputs, ... }:
let
  flakeHosts = import ../lib/flakeHosts.nix inputs;
  allHosts = flakeHosts.discoverHosts ../hosts;
  partitioned = flakeHosts.partitionByType allHosts;
in
{
  flake = {
    nixosConfigurations = partitioned.nixos;
    darwinConfigurations = partitioned.darwin;
  };
}
