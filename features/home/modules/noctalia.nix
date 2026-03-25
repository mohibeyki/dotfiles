{ ... }:
{
  flake.homeModules.noctalia =
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
    };
}
