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

  programs.hyprland = {
    enable = true;
    withUWSM = true;
    package = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland;
    portalPackage =
      inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.xdg-desktop-portal-hyprland;
  };
}
