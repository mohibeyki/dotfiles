{ pkgs, ... }:

let
  user = "mohi";
in
{
  home = {
    username = "${user}";
    homeDirectory = pkgs.lib.mkForce (
      if pkgs.stdenv.isLinux then "/home/${user}" else "/Users/${user}"
    );

    # This value determines the Home Manager release that your configuration is
    # compatible with. This helps avoid breakage when a new Home Manager release
    # introduces backwards incompatible changes.
    #
    # You should not change this value, even if you update Home Manager. If you do
    # want to update the value, then make sure to first check the Home Manager
    # release notes.
    stateVersion = "24.05"; # Please read the comment before changing.

    packages = [
      pkgs.htop
      pkgs.neofetch
    ];

    file = {
      ".config/nvim".source = ../../nvim;
      ".config/helix".source = ../../helix;
      ".config/alacritty".source = ../../alacritty;
      ".config/tmux/tmux.conf".source = ../../tmux/tmux.conf;
    };

    sessionVariables = {
      EDITOR = "nvim";
    };
  };

  programs.git = {
    enable = true;
    userName = "Mohi Beyki";
    userEmail = "mohibeyki@gmail.com";
    ignores = [ ".DS_Store" ];
    extraConfig = {
      init.defaultBranch = "main";
      push.autoSetupRemote = true;
    };
  };

  programs = {
    home-manager.enable = true;
  };
}
