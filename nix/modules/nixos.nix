{ pkgs, ... }:
{
  services.udev.packages = [
    pkgs.gnome-settings-daemon
  ];

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
