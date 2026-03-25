{ inputs, pkgs, ... }:
{
  home = {
    sessionVariables = {
      EDITOR = "nvim";
    };
  };

  programs = {
    home-manager.enable = true;
    man = {
      enable = true;
      generateCaches = false;
    };
  };

  programs = {
    direnv = {
      enable = true;
      nix-direnv.enable = true;
    };

    delta = {
      enable = true;
      enableGitIntegration = true;
    };

    neovim = {
      enable = true;
      package = inputs.neovim-nightly-overlay.packages.${pkgs.stdenv.hostPlatform.system}.default;
      viAlias = true;
      vimAlias = true;
      vimdiffAlias = true;
      withNodeJs = true;
    };
  };
}
