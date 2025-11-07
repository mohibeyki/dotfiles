{
  inputs,
  pkgs,
  ...
}:
{
  imports = [
  ];

  home = {
    sessionVariables = {
      EDITOR = "nvim";
    };

    packages = [ ];
  };

  programs = {
    home-manager = {
      enable = true;
    };

    git = {
      enable = true;
      ignores = [ ".DS_Store" ];
      settings = {
        user = {
          name = "Mohi Beyki";
          email = "mohibeyki@gmail.com";
        };

        alias = {
          co = "checkout";
          ci = "commit";
          st = "status";
          br = "branch";
          hist = "log --pretty=format:'%h %ad | %s%d [%an]' --graph --date=short";
        };

        init.defaultBranch = "main";
        push.autoSetupRemote = true;
      };
    };

    helix = {
      enable = true;
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

  home.stateVersion = "25.05";
}
