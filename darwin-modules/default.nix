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

  system.primaryUser = "mohi";

  nix.gc.interval = [
    {
      Weekday = 7;
      Hour = 3;
      Minute = 15;
    }
  ];

  programs = {
    fish.enable = true;
    # CLI only; the desktop app is the vendor DMG under /Applications.
    _1password.enable = true;
  };

  users.users.mohi = {
    home = "/Users/mohi";
    shell = pkgs.fish;
  };

  environment.systemPackages = [ pkgs.mole-cleaner ];
}
