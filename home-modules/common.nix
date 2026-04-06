{
  inputs,
  pkgs,
  ...
}:
{
  home = {
    sessionVariables = {
      EDITOR = "nvim";
    };

    packages = [
      pkgs.xdg-terminal-exec
      inputs.nixvim.packages.${pkgs.stdenv.hostPlatform.system}.default
    ];
  };

  programs = {
    home-manager.enable = true;

    man = {
      enable = true;
      generateCaches = false;
    };

    direnv = {
      enable = true;
      nix-direnv.enable = true;
    };

    delta = {
      enable = true;
      enableGitIntegration = true;
    };
  };

  xdg.configFile."autostart/blueman.desktop".text = ''
    [Desktop Entry]
    Hidden=true
  '';
}
