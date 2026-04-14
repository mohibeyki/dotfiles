_: {
  programs.zellij = {
    enable = true;
    enableFishIntegration = false;
  };

  xdg.configFile."zellij/config.kdl".source = ./zellij.kdl;
}
