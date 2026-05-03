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

  # Clean up old Home Manager generations weekly (Darwin has no systemd timer).
  launchd.user.agents.home-manager-cleanup = {
    serviceConfig = {
      ProgramArguments = [
        "/bin/sh"
        "-c"
        "exec /nix/var/nix/profiles/per-user/mohi/home-manager/home-manager expire-generations '-30 days' 2>/dev/null || true"
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

  programs.fish.enable = true;

  users.users.mohi = {
    home = "/Users/mohi";
    shell = pkgs.fish;
  };
}
