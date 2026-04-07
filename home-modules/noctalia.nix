{
  config,
  hostConfig,
  lib,
  pkgs,
  ...
}:
let
  monitorNames = map (monitor: monitor.output) (hostConfig.monitors or [ ]);
in
{
  programs.noctalia-shell = {
    enable = true;
    systemd.enable = false;
    package = pkgs.noctalia-shell;
    settings = lib.recursiveUpdate (builtins.fromJSON (builtins.readFile ./noctalia.json)) {
      general = {
        avatarImage = "${config.home.homeDirectory}/Pictures/face.png";
        lockOnSuspend = true;
      };

      idle = {
        enabled = true;
        lockTimeout = 600;
        suspendTimeout = 900;
      };

      wallpaper = {
        directory = "${config.home.homeDirectory}/Pictures/Wallpapers";
        monitorDirectories = map (name: {
          inherit name;
          directory = "${config.home.homeDirectory}/Pictures/Wallpapers";
          wallpaper = "";
        }) monitorNames;
      };
    };
  };

  programs.noctalia-shell.plugins = {
    sources = [
      {
        enabled = true;
        name = "Noctalia Plugins";
        url = "https://github.com/noctalia-dev/noctalia-plugins";
      }
    ];

    states = {
      color-scheme-creator.enable = true;
      file-search.enable = true;
      ip-monitor.enable = true;
      mini-docker.enable = true;
      parallax-wallpaper.enable = true;
      polkit-agent.enable = true;
      screen-recorder.enable = true;

      workspace-overview.settings = {
        compositor = "Hyprland";
      };
    };
  };

  home.file = {
    "Pictures/face.png".source = ../assets/face.png;
    "Pictures/Wallpapers/wallpaper.jpg".source = ../assets/wallpaper.jpg;

    ".cache/noctalia/wallpapers.json".text = builtins.toJSON {
      defaultWallpaper = "${config.home.homeDirectory}/Pictures/Wallpapers/wallpaper.jpg";
      wallpapers = { };
    };
  };
}
