{ inputs, ... }:
{
  flake.homeModules.common =
    { pkgs, ... }:
    {
      home = {
        sessionVariables = {
          EDITOR = "nvim";
        };
      };

      programs = {
        home-manager.enable = true;
      };

      home = {
        username = "mohi";
        stateVersion = "26.05";
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
    };
}
