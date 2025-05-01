{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    bind
    brave
    discord
    gparted
    adwaita-icon-theme
    mako
    niv
    sbctl
    zed-editor
  ];
}
