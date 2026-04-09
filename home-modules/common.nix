{
  inputs,
  pkgs,
  ...
}:
{
  home = {
    sessionVariables = {
      # Primary editor: Neovim (via custom nixvim config from github.com/mohibeyki/nixvim)
      EDITOR = "nvim";
      # Rootless Docker socket location
      DOCKER_HOST = "unix://$XDG_RUNTIME_DIR/docker.sock";
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
