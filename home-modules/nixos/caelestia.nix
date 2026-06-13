{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (config.dotfiles) host;
in
lib.mkIf (host.shell == "caelestia") {
  programs.caelestia = {
    enable = true;
    systemd = {
      enable = false;
      target = "graphical-session.target";
    };
    cli = {
      enable = true;
    };
  };

  home.packages = [
    pkgs.kdePackages.kirigami.unwrapped
  ] ++ (with pkgs.kdePackages; [
    kirigami-addons
    qqc2-breeze-style
  ]);

  home.sessionVariables.NIXPKGS_QT6_QML_IMPORT_PATH = lib.makeSearchPath "lib/qt-6/qml" [
    pkgs.kdePackages.kirigami.unwrapped
    pkgs.kdePackages.qqc2-breeze-style
    pkgs.kdePackages.qqc2-desktop-style
  ];

  home.file = {
    "Pictures/face.png".source = ../../assets/face.png;
    "Pictures/Wallpapers/wallpaper.jpg".source = ../../assets/wallpaper.jpg;
  };
}
