{ pkgs, ... }:
{
  services.udev.packages = [
    pkgs.gnome.gnome-settings-daemon
  ];

  environment.systemPackages = with pkgs; [
    alacritty
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
