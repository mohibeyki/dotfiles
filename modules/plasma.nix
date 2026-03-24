{ pkgs, ... }:
{
  services = {
    desktopManager = {
      plasma6.enable = true;
    };

    displayManager = {
      sddm = {
        enable = true;
        theme = "pixie";
        wayland.enable = true;
      };
    };
  };

  security.pam.services = {
    sddm.kwallet.enable = true;
  };

  systemd.user.targets.graphical-session.wants = [ "plasma-kwallet-pam.service" ];

  environment.systemPackages = with pkgs.kdePackages; [
    (pkgs.stdenv.mkDerivation {
      pname = "pixie-sddm";
      version = "2026-03-22";
      src = pkgs.fetchFromGitHub {
        owner = "xCaptaiN09";
        repo = "pixie-sddm";
        rev = "12a5f459ebd6d699be42c188c10976c8bb7076d7";
        sha256 = "sha256-lmE/49ySuAZDh5xLochWqfSw9qWrIV+fYaK5T2Ckck8=";
      };
      dontBuild = true;
      installPhase = ''
        mkdir -p "$out/share/sddm/themes/pixie"
        cp -r ./* "$out/share/sddm/themes/pixie/"
      '';
    })
    ark
    breeze-gtk
    breeze-icons
    discover
    dolphin
    dolphin-plugins
    ffmpegthumbs
    gwenview
    kate
    kcalc
    kcharselect
    kclock
    kcolorchooser
    ksystemlog
    partitionmanager
    kde-gtk-config
    kdegraphics-thumbnailers
    kdenlive
    kio-extras
    konsole
    kscreen
    kwallet
    kwallet-pam
    okular
    partitionmanager
    plasma-browser-integration
    plasma-nm
    plasma-pa
    plasma-systemmonitor
    powerdevil
    qt5compat
    qtdeclarative
    qtsvg
    spectacle
    systemsettings
    xdg-desktop-portal-kde
  ];

  programs.kde-pim.merkuro = false;
  programs.kdeconnect.enable = true;
}
