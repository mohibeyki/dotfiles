{ pkgs, inputs, ... }:
{
  environment.systemPackages = [
    inputs.ghostty.packages.${pkgs.stdenv.hostPlatform.system}.default
  ];
}
