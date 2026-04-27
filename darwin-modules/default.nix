{
  inputs,
  pkgs,
  ...
}:
{
  imports = [
    inputs.home-manager.darwinModules.home-manager
    ../modules/system-dev.nix
    ../modules/shared.nix
  ];

  nix.gc.interval = [
    {
      Weekday = 7;
      Hour = 3;
      Minute = 15;
    }
  ];

  programs.fish.enable = true;

  users.users.mohi = {
    home = "/Users/mohi";
    shell = pkgs.fish;
  };
}
