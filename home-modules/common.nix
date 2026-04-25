{
  config,
  pkgs,
  ...
}:
{
  home = {
    sessionVariables = {
      EDITOR = "nvim";
    };

    sessionPath = [
      "${config.home.homeDirectory}/.local/share/npm/bin"
    ];
  };

  programs = {
    home-manager.enable = true;

    npm = {
      enable = true;
      settings = {
        prefix = "${config.home.homeDirectory}/.local/share/npm";
        cache = "${config.home.homeDirectory}/.cache/npm";
      };
    };

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

}
