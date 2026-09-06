{
  lib,
  pkgs,
  ...
}:
{
  systemd.user.services.proton-pass = {
    Unit = {
      Description = "Proton Pass desktop application";
      After = [ "graphical-session.target" ];
      PartOf = [ "graphical-session.target" ];
    };

    Service = {
      ExecStart = lib.getExe pkgs.proton-pass;
      Restart = "always";
      RestartSec = 5;
    };

    Install.WantedBy = [ "graphical-session.target" ];
  };
}
