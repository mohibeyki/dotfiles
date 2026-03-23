{
  inputs,
  pkgs,
  ...
}:
{
  imports = [
    inputs.noctalia-shell.homeModules.default
  ];

  programs.noctalia-shell = {
    enable = true;
    systemd.enable = true;
    package = inputs.noctalia-shell.packages.${pkgs.stdenv.hostPlatform.system}.default;
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
      polkit-agent.enable = true;
      screen-recorder.enable = true;
      color-scheme-creator.enable = true;
      parallax-wallpaper.enable = true;
      ip-monitor.enable = true;
      mini-docker.enable = true;
      workspace-overview.settings = {
        compositor = "Hyprland";
      };
      file-search.enable = true;
    };
  };
}
