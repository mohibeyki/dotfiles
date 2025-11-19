{ pkgs, config, ... }:
{
  ids.gids.nixbld = 350;

  environment.systemPackages = [
    pkgs.aerospace
    pkgs.mkalias
  ];
}
