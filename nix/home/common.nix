{ pkgs, inputs, ... }:
let
  username = "mohi";
in
{
  imports = [
  ];

  home = {
    username = "${username}";
    homeDirectory = pkgs.lib.mkForce (
      if pkgs.stdenv.isLinux then "/home/${username}" else "/Users/${username}"
    );

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
      package = inputs.helix.packages.${pkgs.system}.default;
    };

    neovim = {
      enable = true;
      package = inputs.neovim-nightly-overlay.packages.${pkgs.system}.default;
      viAlias = true;
      vimAlias = true;
      vimdiffAlias = true;
      withNodeJs = true;

      extraPackages = with pkgs; [
        gofumpt
        golangci-lint
        gopls
        gotools
        stylua
        taplo
        tree-sitter
        lua-language-server
        markdownlint-cli2
        marksman
        nil
        nixd
        nixfmt-rfc-style
        selene
        statix
      ];
    };
  };

  home.stateVersion = "24.05";
}
