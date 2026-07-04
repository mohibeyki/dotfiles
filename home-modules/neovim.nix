{
  pkgs,
  ...
}:
{
  home = {
    packages = [ pkgs.neovim ];

    shellAliases = {
      vi = "nvim";
      vim = "nvim";
      vimdiff = "nvim -d";
    };

    sessionVariables.EDITOR = "nvim";
  };
}
