{ inputs, pkgs, ... }:
{
  imports = [ inputs.hyprland.nixosModules.default ];

  programs = {
    uwsm.enable = true;

    hyprland = {
      enable = true;
      withUWSM = true;
      package = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland;
      portalPackage =
        inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.xdg-desktop-portal-hyprland;
    };
  };

  environment.systemPackages = with pkgs; [
    hypridle
    hyprland
    hyprlock
    hyprpaper
    hyprshot
    swaynotificationcenter
    waybar
    wlogout
    wl-clipboard-rs
    wofi
    xdg-desktop-portal-gtk
    xdg-desktop-portal-hyprland
  ];
}
