{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.mohi.desktop;
in
lib.mkIf (cfg.mode == "plasma") {
  services.desktopManager.plasma6.enable = true;

  programs.dconf.enable = true;

  environment.systemPackages = with pkgs; [
    kdePackages.ark
    kdePackages.audiotube
    kdePackages.dolphin
    kdePackages.dragon
    kdePackages.elisa
    kdePackages.filelight
    kdePackages.gwenview
    kdePackages.isoimagewriter
    kdePackages.kaddressbook
    kdePackages.kalk
    kdePackages.kamera
    kdePackages.kamoso
    kdePackages.kate
    kdePackages.kcalc
    kdePackages.kcharselect
    kdePackages.kcolorchooser
    kdePackages.kcron
    kdePackages.kdeconnect-kde
    kdePackages.kdf
    kdePackages.kdialog
    kdePackages.discover
    kdePackages.kfind
    kdePackages.kgpg
    kdePackages.khelpcenter
    kdePackages.kleopatra
    kdePackages.kmail
    kdePackages.kmix
    kdePackages.konsole
    kdePackages.kontact
    kdePackages.korganizer
    kdePackages.krdc
    kdePackages.krfb
    kdePackages.kscreen
    kdePackages.ksystemlog
    kdePackages.okular
    kdePackages.partitionmanager
    kdePackages.plasmatube
    kdePackages.skanpage
    kdePackages.spectacle
  ];
}
