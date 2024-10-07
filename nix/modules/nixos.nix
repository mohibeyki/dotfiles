{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    alacritty
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
