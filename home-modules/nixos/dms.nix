{
  inputs,
  lib,
  pkgs,
  ...
}:
{
  programs.dank-material-shell = {
    enable = true;
    enableDynamicTheming = false;
    enableCalendarEvents = true;
    enableSystemMonitoring = true;
    enableVPN = true;
    enableAudioWavelength = true;
    systemd = {
      enable = true;
      target = "wayland-session@hyprland.desktop.target";
    };

    settings = {
      configVersion = 17;
      currentThemeName = "purple";
    };

    clipboardSettings = {
      maxHistory = 50;
      maxEntrySize = 5242880;
      disabled = false;
      disableHistory = false;
      disablePersist = false;
    };

    plugins = {
      dankKDEConnect.enable = true;
      dockerManager.enable = true;
      quickCapture.enable = true;
      calculator.enable = true;
    };
  };

  home.packages = [
    inputs.dgop.packages.${pkgs.stdenv.hostPlatform.system}.default
    pkgs.kdePackages.kdeconnect-kde
    pkgs.gpu-screen-recorder
    pkgs.wf-recorder
    pkgs.ffmpeg
    pkgs.imagemagick
    pkgs.img2pdf
    pkgs.tesseract
    pkgs.zbar
  ];

  systemd.user.services.dms.Unit.After = lib.mkForce [
    "wayland-wm@hyprland.desktop.service"
    "wayland-session-waitenv.service"
  ];
}
