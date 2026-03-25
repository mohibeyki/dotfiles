{ pkgs, ... }:
{
  programs.noctalia-shell = {
    enable = true;
    systemd.enable = true;
    package = pkgs.noctalia-shell;
    settings = ./noctalia.json;
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
}
