{ pkgs, inputs, ... }:
let
  hyprpkgs = inputs.hyprland.inputs.nixpkgs.legacyPackages.${pkgs.stdenv.hostPlatform.system};
  hyprpkgs-contrib = inputs.hyprland-contrib.packages.${pkgs.stdenv.hostPlatform.system};
in
{
  hardware = {
    graphics = {
      package = hyprpkgs.mesa.drivers;
      package32 = hyprpkgs.pkgsi686Linux.mesa.drivers;
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
    package = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland;
    portalPackage =
      inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.xdg-desktop-portal-hyprland;
  };

  environment.systemPackages = [
    pkgs.hyprpaper
    pkgs.lxqt.lxqt-policykit
    pkgs.vimix-cursors
    pkgs.waybar
    pkgs.wofi

    hyprpkgs-contrib.hyprprop

    (pkgs.waybar.overrideAttrs (oldAttrs: {
      mesonFlags = oldAttrs.mesonFlags ++ [ "-Dexperimental=true" ];
    }))
  ];
}
