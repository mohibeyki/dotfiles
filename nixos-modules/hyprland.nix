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

  systemd.user.services.xdg-desktop-portal-hyprland.serviceConfig.ExecCondition =
    "${pkgs.runtimeShell} -c 'case \":$XDG_CURRENT_DESKTOP:\" in *:Hyprland:*|*:hyprland:*) exit 0;; *) exit 1;; esac'";
}
