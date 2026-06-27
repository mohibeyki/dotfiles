{
  inputs,
  pkgs,
  lib,
  ...
}:
let
  hyprlandPkg = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland;

  mkShellWrapper =
    shellName:
    pkgs.writeShellScript "hyprland-${shellName}" ''
      export DOTFILES_SHELL=${lib.escapeShellArg shellName}
      exec ${hyprlandPkg}/bin/start-hyprland
    '';

  # Custom desktop entry that uses uwsm start -e -D Hyprland with the wrapper
  # script, so XDG_CURRENT_DESKTOP is set to Hyprland (not a hash-prefixed name).
  mkShellSession =
    shellName:
    let
      wrapper = mkShellWrapper shellName;
      prettyName = if shellName == "caelestia" then "Caelestia" else "Noctalia";
    in
    pkgs.writeTextFile {
      name = "hyprland-${shellName}-uwsm";
      text = ''
        [Desktop Entry]
        Name=Hyprland (${prettyName}) (UWSM)
        Comment=Hyprland compositor with ${prettyName} shell
        Exec=${pkgs.uwsm}/bin/uwsm start -e -D Hyprland ${wrapper}
        Type=Application
        DesktopNames=Hyprland
      '';
      destination = "/share/wayland-sessions/hyprland-${shellName}-uwsm.desktop";
      derivationArgs = {
        passthru.providedSessions = [ "hyprland-${shellName}-uwsm" ];
      };
    };

  shellSessions = [ (mkShellSession "caelestia") (mkShellSession "noctalia") ];
in
{
  environment.systemPackages = with pkgs; [
      cliphist
      grimblast
      pavucontrol
      playerctl
    ]
    ++ shellSessions;

  programs.hyprland = {
    enable = true;
    withUWSM = true;
    package = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland;
    portalPackage =
      inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.xdg-desktop-portal-hyprland;
  };

  services.displayManager.sessionPackages = shellSessions;

  systemd.user.services.xdg-desktop-portal-hyprland.serviceConfig.ExecCondition =
    "${pkgs.runtimeShell} -c 'case \":$XDG_CURRENT_DESKTOP:\" in *:Hyprland:*|*:hyprland:*) exit 0;; *) exit 1;; esac'";
}
