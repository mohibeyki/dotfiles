{ inputs, pkgs, ... }:
{
  imports = [ inputs.hyprland.nixosModules.default ];

  programs.hyprland = {
    enable = true;
    package = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland;
    portalPackage =
      inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.xdg-desktop-portal-hyprland;
  };

  environment.systemPackages = with pkgs; [
    hypridle
    hyprland
    hyprlock
    hyprpaper
    waybar
    wofi
    xdg-desktop-portal-hyprland
  ];
}
