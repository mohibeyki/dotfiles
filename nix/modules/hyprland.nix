{ pkgs, hyprland, ... }:
{
  hardware = {
    graphics = {
      enable32Bit = true;
    };
  };

  environment.sessionVariables = {
    WLR_NO_HARDWARE_CURSOR = "1";
    NIXOS_OZONE_WL = "1";
  };

  xdg.portal = {
    enable = true;
    extraPortals = [
      pkgs.xdg-desktop-portal-gtk
    ];
  };

  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
    package = hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland;
    portalPackage = hyprland.packages.${pkgs.stdenv.hostPlatform.system}.xdg-desktop-portal-hyprland;
  };

  environment.systemPackages = [
    pkgs.hyprpaper
    pkgs.lxqt.lxqt-policykit
    pkgs.vimix-cursors
    pkgs.waybar
    pkgs.wofi
  ];
}
