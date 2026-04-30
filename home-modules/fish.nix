{
  pkgs,
  ...
}:
{
  programs.fish = {
    enable = true;

    plugins = [
      {
        name = "tide";
        inherit (pkgs.fishPlugins.tide) src;
      }
    ];

    shellInit = ''
      set -gx PILENS_DATA_DIR "$HOME/.pi/pi-lens/projects"
    '';

    interactiveShellInit = ''
      set -g tide_context_always_display true
      set -g tide_context_hostname_parts 1
    '';

    shellAliases = {
      vi = "nvim";
      vim = "nvim";
      vimdiff = "nvim -d";
      ls = "eza --icons";
      ll = "eza -la --icons --git";
      la = "eza -a --icons";
      tree = "eza --tree --icons";
    };
  };
}
