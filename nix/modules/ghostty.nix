{ pkgs, ghostty, ... }:
{
  environment.systemPackages = [
    ghostty.packages.${pkgs.stdenv.hostPlatform.system}.default
  ];
}
