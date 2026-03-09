{ pkgs, ... }:
{
  programs.fish = {
    enable = true;

    plugins = [
      {
        name = "tide";
        src = pkgs.fishPlugins.tide.src;
      }
    ];

    interactiveShellInit = ''
      set -U tide_context_always_display true
      set -U tide_context_hostname_parts 1
    '';
  };
}
