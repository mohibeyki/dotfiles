{ pkgs, inputs, ... }:
let
  username = "mohi";
  configPath = ../../config;
in
{
  imports =
    [
    ];

  home = {
    username = "${username}";
    homeDirectory = pkgs.lib.mkForce (
      if pkgs.stdenv.isLinux then "/home/${username}" else "/Users/${username}"
    );

    file = {
      ".config/alacritty".source = configPath + /alacritty;
      ".config/helix".source = configPath + /helix;
      ".config/wezterm".source = configPath + /wezterm;
      ".config/tmux/tmux.conf".source = configPath + /tmux/tmux.conf;
    };

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

    neovim = {
      enable = true;
      vimAlias = true;
      vimdiffAlias = true;
      withNodeJs = true;

      plugins = with pkgs.vimPlugins; [
        lazy-nvim
      ];
    };
  };

  xdg.configFile."nvim" = {
    recursive = true;
    source = ../../config/nvim;
  };

  home.stateVersion = "24.05";
}
