{ pkgs, ... }:
{
  services = {
    gnome.gnome-keyring.enable = true;
    gvfs.enable = true;
  };

  security = {
    polkit.enable = true;
  };

  environment.systemPackages = with pkgs; [
    bind
    blueman
    brave
    discord
    ghostty
    gparted
    kdePackages.kate
    killall
    lshw
    mousam
    niv
    pipewire
    telegram-desktop
    wayland-utils
    wiremix
    wireplumber
    wl-clipboard
  ];
}
