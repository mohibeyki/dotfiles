{ ... }:
{
  flake.homeModules.zellij = {
    programs.zellij = {
      enable = true;
    };

    xdg.configFile."zellij/config.kdl".source = ./zellij.kdl;
  };
}
