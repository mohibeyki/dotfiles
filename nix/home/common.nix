{ pkgs, ... }:
let
  username = "mohi";
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
      ".config/alacritty".source = ../../config/alacritty;
      ".config/helix".source = ../../config/helix;
      ".config/wezterm".source = ../../config/wezterm;
      ".config/tmux/tmux.conf".source = ../../config/tmux/tmux.conf;
    };

    sessionVariables = {
      EDITOR = "nvim";
    };
  };

  home.packages = [ ];

  programs = {
    neovim.enable = true;
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
  };

  home.stateVersion = "24.05";
}
