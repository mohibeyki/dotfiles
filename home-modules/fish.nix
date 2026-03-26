{ pkgs, ... }:
{
  programs.fish = {
    enable = true;

    plugins = [
      {
        name = "tide";
        inherit (pkgs.fishPlugins.tide) src;
      }
    ];

    interactiveShellInit = ''
      set -g tide_context_always_display true
      set -g tide_context_hostname_parts 1
    '';
  };
}
