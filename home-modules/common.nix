{ inputs, pkgs, ... }:
{
  home = {
    sessionVariables = {
      EDITOR = "nvim";
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
      package = pkgs.man;
    };

    direnv = {
      enable = true;
      nix-direnv.enable = true;
    };

    delta = {
      enable = true;
      enableGitIntegration = true;
    };

    zoxide = {
      enable = true;
      enableFishIntegration = true;
    };

    fzf = {
      enable = true;
      enableFishIntegration = true;
    };
  };

  xdg.configFile."docker/daemon.json".text = builtins.toJSON {
    dns = [
      "192.168.1.10"
      "1.1.1.1"
      "8.8.8.8"
    ];
  };
}
