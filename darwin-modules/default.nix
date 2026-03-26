{
  inputs,
  pkgs,
  overlays ? [ ],
  ...
}:
{
  imports = [
    inputs.home-manager.darwinModules.home-manager
    ../modules/dev.nix
    ../modules/shared.nix
  ];

  nixpkgs.overlays = overlays;

  programs.fish.enable = true;

  users.users.mohi = {
    home = "/Users/mohi";
    shell = pkgs.fish;
  };
}
