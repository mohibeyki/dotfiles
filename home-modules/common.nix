{
  inputs,
  pkgs,
  ...
}:
{
  home = {
    sessionVariables = {
      EDITOR = "nvim";
    };

    packages = [
      inputs.nixvim.packages.${pkgs.stdenv.hostPlatform.system}.default
    ]
    ++ pkgs.lib.optionals (!pkgs.stdenv.isDarwin) [ pkgs.xdg-terminal-exec ];
  };

  programs = {
    home-manager.enable = true;

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
