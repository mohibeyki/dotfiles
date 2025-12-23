{
  inputs,
  pkgs,
  ...
}:
{
  imports = [
    ./modules/fish.nix
    ./modules/ghostty.nix
    ./modules/helix.nix
    ./modules/tmux.nix
    ./modules/zellij.nix
  ];

  home = {
    sessionVariables = {
      EDITOR = "nvim";
    };
  };

  programs = {
    home-manager.enable = true;

    direnv = {
      enable = true;
      nix-direnv.enable = true;
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

    neovim = {
      enable = true;
      package = inputs.neovim-nightly-overlay.packages.${pkgs.stdenv.hostPlatform.system}.default;
      viAlias = true;
      vimAlias = true;
      vimdiffAlias = true;
      withNodeJs = true;
    };
  };

  # Used for backwards compatibility with home-manager
  # See: https://nix-community.github.io/home-manager/release-notes.xhtml
  home.stateVersion = "25.11"; # Latest home-manager state version
}
