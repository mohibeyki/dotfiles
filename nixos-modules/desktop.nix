{ pkgs, ... }:
{
  services = {
    displayManager = {
      defaultSession = "hyprland-uwsm";
      sddm = {
        enable = true;
        wayland.enable = true;
        theme = "noctalia";
      };
    };

    desktopManager.plasma6.enable = true;
  };

  security.pam.services.sddm.kwallet.enable = true;

  hardware = {
    graphics = {
      enable = true;
      enable32Bit = true;
    };
  };

  environment.systemPackages = with pkgs; [
    bind
    brave
    cider-2
    compsize
    curl
    discord
    easyeffects
    gparted
    jq
    kdiskmark
    killall
    lshw
    mousam
    p7zip
    streamcontroller
    teamspeak6-client
    telegram-desktop
    transmission_4-gtk
    wayland-utils
    websocat
    wiremix
    wl-clipboard
  ];
}
