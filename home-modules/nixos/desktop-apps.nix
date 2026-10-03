{
  config,
  lib,
  pkgs,
  ...
}:
let
  # Desktop launchers do not necessarily source the shell initialization that
  # sets DOCKER_HOST. Point this launcher explicitly at Sauron's rootless daemon.
  rootlessLazydocker = pkgs.writeShellScript "rootless-lazydocker" ''
    export DOCKER_HOST="unix://''${XDG_RUNTIME_DIR:?XDG_RUNTIME_DIR is not set}/docker.sock"
    exec ${lib.getExe pkgs.lazydocker} "$@"
  '';

  tuiEntry =
    id:
    {
      name,
      comment,
      icon,
      command,
      categories,
    }:
    let
      appId = "com.mohi.tui.${id}";
    in
    {
      inherit
        name
        comment
        icon
        categories
        ;
      # A separate process gives each tool its own window identity and lifetime.
      exec = ''${lib.getExe config.programs.ghostty.package} --gtk-single-instance=false --class=${appId} --title="${name}" --working-directory="${config.home.homeDirectory}" -e ${command}'';
      terminal = false;
      settings.StartupWMClass = appId;
    };
in
{
  home.packages = with pkgs; [
    localsend
    lazydocker
  ];

  xdg.desktopEntries = {
    lazydocker = tuiEntry "lazydocker" {
      name = "Lazydocker";
      comment = "Manage rootless Docker containers, images, and logs";
      icon = "applications-development";
      command = rootlessLazydocker;
      categories = [ "Development" ];
    };

    btop = tuiEntry "btop" {
      name = "Activity Monitor";
      comment = "Monitor CPU, GPU, memory, and processes with btop";
      icon = "utilities-system-monitor";
      command = lib.getExe pkgs.btop;
      categories = [ "System" ];
    };

    dua = tuiEntry "dua" {
      name = "Disk Usage";
      comment = "Explore home directory disk usage with dua";
      icon = "drive-harddisk";
      command = "${lib.getExe pkgs.dua} interactive";
      categories = [ "System" ];
    };

    yazi = tuiEntry "yazi" {
      name = "Files (Terminal)";
      comment = "Browse files with yazi";
      icon = "system-file-manager";
      command = lib.getExe pkgs.yazi;
      categories = [
        "System"
        "FileManager"
      ];
    };

    grok = {
      name = "Grok";
      comment = "Open Grok in a dedicated Brave Origin window";
      exec = "${lib.getExe pkgs.brave-origin} --app=https://grok.com/";
      icon = "brave-origin";
      terminal = false;
      categories = [ "Network" ];
    };
  };
}
