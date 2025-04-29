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
    home-manager.enable = true;

    git = {
      enable = true;
      userName = "Mohi Beyki";
      userEmail = "mohibeyki@gmail.com";
      ignores = [ ".DS_Store" ];
      extraConfig = {
        init.defaultBranch = "main";
        push.autoSetupRemote = true;
      };

      aliases = {
        co = "checkout";
        ci = "commit";
        st = "status";
        br = "branch";
        hist = "log --pretty=format:'%h %ad | %s%d [%an]' --graph --date=short";
      };
    };

    helix = {
      enable = true;
    };

    neovim = {
      enable = true;
      package = inputs.neovim-nightly-overlay.packages.${pkgs.system}.default;
      viAlias = true;
      vimAlias = true;
      vimdiffAlias = true;
      withNodeJs = true;
    };
  };

  home.stateVersion = "24.11";
}
