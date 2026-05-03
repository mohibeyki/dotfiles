{
  pkgs,
  ...
}:
{
  home.packages = [ pkgs.neovim ];

  home.shellAliases = {
    vi = "nvim";
    vim = "nvim";
    vimdiff = "nvim -d";
  };

  home.sessionVariables.EDITOR = "nvim";
}
