{
  pkgs,
  ...
}:
{
  services = {
    displayManager.gdm.enable = true;

    gnome.gnome-keyring.enable = true;
    gvfs.enable = true;
  };

  hardware = {
    graphics = {
      enable = true;
      enable32Bit = true;
    };
  };

  environment.systemPackages = with pkgs; [
    bind
    blueman
    brave
    cider-2
    compsize
    curl
    discord
    easyeffects
    ghostty
    glibc
    gparted
    jq
    killall
    lshw
    mousam
    niv
    p7zip
    streamcontroller
    teamspeak6-client
    telegram-desktop
    transmission_4-gtk
    wayland-utils
    websocat
    wget
    wiremix
    wl-clipboard
    zenity
  ];
}
