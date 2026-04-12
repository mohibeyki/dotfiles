{
  inputs,
  pkgs,
  ...
}:
{
  environment.systemPackages = with pkgs; [
    cliphist
    grimblast
    pavucontrol
    playerctl
  ];

  systemd.services.display-manager.path = [ pkgs.uwsm ];

  xdg.portal = {
    enable = true;
    config = {
      hyprland = {
        default = [
          "hyprland"
          "kde"
        ];
        "org.freedesktop.impl.portal.FileChooser" = [ "kde" ];
        "org.freedesktop.impl.portal.Inhibit" = [ "hyprland" ];
        "org.freedesktop.impl.portal.OpenURI" = [ "kde" ];
        "org.freedesktop.impl.portal.Settings" = [ "kde" ];
        "org.freedesktop.impl.portal.Secret" = [ "kde" ];
      };
    };

    extraPortals = [ pkgs.kdePackages.xdg-desktop-portal-kde ];
  };

  programs.hyprland = {
    enable = true;
    withUWSM = true;
    package = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland;
    portalPackage =
      inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.xdg-desktop-portal-hyprland;
  };
}
