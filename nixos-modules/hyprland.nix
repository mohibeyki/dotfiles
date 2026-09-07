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

  # Own portals at the system level; Plasma supplies KDE's implementation.
  # Do not also install a second portal service through Home Manager.
  xdg.portal.config.hyprland = {
    default = [
      "hyprland"
      "kde"
      "gtk"
    ];
    "org.freedesktop.impl.portal.FileChooser" = [ "kde" ];
  };

  # The login screen does not need a screencasting portal. Its compositor exits
  # at login, leaving a stale environment and a portal restart loop behind.
  systemd.user.services.xdg-desktop-portal-hyprland.unitConfig.ConditionUser = "!dms-greeter";
  systemd.user.services.xdg-desktop-portal-hyprland.serviceConfig.ExecCondition =
    "${pkgs.runtimeShell} -c 'case \":$XDG_CURRENT_DESKTOP:\" in *:Hyprland:*|*:hyprland:*) exit 0;; *) exit 1;; esac'";
}
