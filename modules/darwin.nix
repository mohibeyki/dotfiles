{ pkgs, ... }:
{
  ids.gids.nixbld = 350;

  environment.systemPackages = [
    pkgs.mkalias
  ];
}
