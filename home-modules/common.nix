{
  config,
  lib,
  pkgs,
  ...
}:
{
  home = {
    sessionPath = [
      "${config.home.homeDirectory}/.local/share/npm/bin"
    ];
  };

  services.home-manager.autoExpire = lib.mkIf pkgs.stdenv.isLinux {
    enable = true;
    timestamp = "-7 days";
    frequency = "weekly";
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

    nix-index = {
      enable = true;
      enableFishIntegration = true;
    };
  };

  home.packages = [ pkgs.comma ];

}
