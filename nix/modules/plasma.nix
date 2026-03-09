{ pkgs, ... }:
{
  services.desktopManager.plasma6.enable = true;

  environment.systemPackages = with pkgs.kdePackages; [
    ark
    breeze-gtk
    breeze-icons
    dolphin
    dolphin-plugins
    ffmpegthumbs
    gwenview
    kate
    kcalc
    kde-gtk-config
    kdegraphics-thumbnailers
    kdenlive
    kio-extras
    konsole
    kscreen
    kwallet
    okular
    partitionmanager
    plasma-browser-integration
    plasma-nm
    plasma-pa
    plasma-systemmonitor
    powerdevil
    spectacle
    systemsettings
  ];

  programs.kde-pim.merkuro = false;
  programs.kdeconnect.enable = true;

  security.pam.services.kwallet = {
    enableKwallet = true;
  };
}
