{
  inputs,
  lib,
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

  # Clean up old Home Manager generations weekly (Darwin has no systemd timer).
  launchd.user.agents.home-manager-cleanup = {
    serviceConfig = {
      ProgramArguments = [
        (lib.getExe pkgs.home-manager)
        "expire-generations"
        "-30 days"
      ];
      StartCalendarInterval = [
        {
          Weekday = 7;
          Hour = 4;
          Minute = 15;
        }
      ];
      RunAtLoad = false;
    };
  };

  programs = {
    fish.enable = true;
    # CLI only; the desktop app is the vendor DMG under /Applications.
    _1password.enable = true;
  };

  users.users.mohi = {
    home = "/Users/mohi";
    shell = pkgs.fish;
  };
}
