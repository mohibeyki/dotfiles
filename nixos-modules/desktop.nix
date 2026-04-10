{
  inputs,
  pkgs,
  ...
}:
{
  services = {
    displayManager.ly.enable = true;
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
    kdiskmark
    killall
    lshw
    mousam
    nemo
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
    inputs.rose-pine-hyprcursor.packages.${pkgs.stdenv.hostPlatform.system}.default
  ];
}
