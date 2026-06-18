{
  config,
  inputs,
  lib,
  pkgs,
  ...
}:
let
  inherit (config.dotfiles) host;

  shellPackage = inputs.caelestia-shell.packages.${pkgs.stdenv.hostPlatform.system}.with-cli;

  qmlDeps = [
    pkgs.kdePackages.kirigami.unwrapped
    pkgs.kdePackages.kirigami-addons
    pkgs.kdePackages.qqc2-breeze-style
    pkgs.kdePackages.qqc2-desktop-style
  ];

  libDeps = [
    pkgs.kdePackages.kirigami.unwrapped
    pkgs.kdePackages.qqc2-breeze-style
    pkgs.kdePackages.qqc2-desktop-style
  ];

  qmlImportPath = lib.makeSearchPath "lib/qt-6/qml" qmlDeps;
  libPath = lib.makeLibraryPath libDeps;

  shellWrapped = pkgs.runCommand "caelestia-shell-wrapped" {
    nativeBuildInputs = [ pkgs.makeWrapper ];
  } ''
    mkdir -p $out
    cp -rL ${shellPackage}/. $out/
    chmod -R u+w $out
    mv $out/bin/caelestia-shell $out/bin/.caelestia-shell-upstream
    makeWrapper $out/bin/.caelestia-shell-upstream $out/bin/caelestia-shell \
      --prefix NIXPKGS_QT6_QML_IMPORT_PATH : "${qmlImportPath}" \
      --prefix QML2_IMPORT_PATH : "${qmlImportPath}" \
      --prefix LD_LIBRARY_PATH : "${libPath}"
  '';
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
    package = shellWrapped;
    settings = {
      general.idle = {
        lockBeforeSleep = false;
        inhibitWhenAudio = false;
        timeouts = [];
      };
    };
  };

  home.packages = qmlDeps;

  home.sessionVariables = {
    NIXPKGS_QT6_QML_IMPORT_PATH = qmlImportPath;
    QML2_IMPORT_PATH = qmlImportPath;
  };

  home.file = {
    "Pictures/face.png".source = ../../assets/face.png;
    "Pictures/Wallpapers/wallpaper.jpg".source = ../../assets/wallpaper.jpg;
  };
}
