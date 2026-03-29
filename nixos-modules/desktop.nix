{ pkgs, ... }:
{
  services = {
    gnome.gnome-keyring.enable = true;
    gvfs.enable = true;
  };

  hardware = {
    graphics = {
      enable = true;
      enable32Bit = true;
    };
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
    telegram-desktop
    wayland-utils
    wiremix
    wl-clipboard
  ];
}
