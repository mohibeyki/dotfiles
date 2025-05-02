{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    adwaita-icon-theme
    bind
    brave
    discord
    gparted
    mako
    niv
    sbctl
    zed-editor
  ];
}
