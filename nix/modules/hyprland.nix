{ inputs, pkgs, ... }:
let
  pkgs-unstable = inputs.hyprland.inputs.nixpkgs.legacyPackages.${pkgs.stdenv.hostPlatform.system};
in
{
  imports = [ inputs.hyprland.nixosModules.default ];

  hardware.graphics = {
    package = pkgs-unstable.mesa;

    # 32 bit support
    enable32Bit = true;
    package32 = pkgs-unstable.pkgsi686Linux.mesa;
  };

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
