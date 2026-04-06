{
  config,
  inputs,
  lib,
  pkgs,
  ...
}:
let
  desktopMode = config.mohi.desktop.mode;
  desktopPortalPackage =
    if desktopMode == "plasma" then
      pkgs.kdePackages.xdg-desktop-portal-kde
    else
      pkgs.xdg-desktop-portal-gtk;
  desktopPortalName = if desktopMode == "plasma" then "kde" else "gtk";
in
{
  environment.systemPackages = with pkgs; [
    cliphist
    pavucontrol
    playerctl
  ];

  systemd.services.display-manager.path = [ pkgs.uwsm ];

  xdg.portal = {
    enable = true;
    xdgOpenUsePortal = true;

    extraPortals = [
      desktopPortalPackage
      inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.xdg-desktop-portal-hyprland
    ]
    ++ lib.optionals (desktopMode == "gnome") [ pkgs.xdg-desktop-portal-gnome ];

    config = {
      hyprland = {
        default = [
          "hyprland"
          desktopPortalName
        ];
        "org.freedesktop.impl.portal.FileChooser" = [ desktopPortalName ];
        "org.freedesktop.impl.portal.Inhibit" = [ desktopPortalName ];
        "org.freedesktop.impl.portal.OpenURI" = [ desktopPortalName ];
        "org.freedesktop.impl.portal.Settings" = [ desktopPortalName ];
      }
      // lib.optionalAttrs (desktopMode == "gnome") {
        "org.freedesktop.impl.portal.Secret" = [ "gnome-keyring" ];
      };
    };
  };

  programs.hyprland = {
    enable = true;
    withUWSM = true;
    package = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland;
    portalPackage =
      inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.xdg-desktop-portal-hyprland;
  };
}
