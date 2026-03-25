{ inputs, pkgs, ... }:
{
  imports = [
    inputs.home-manager.darwinModules.home-manager
  ];

  nixpkgs.config.allowUnfree = true;

  users.users.mohi = {
    home = "/Users/mohi";
    shell = pkgs.zsh;
  };

}
