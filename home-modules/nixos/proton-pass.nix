{
  lib,
  pkgs,
  ...
}:
{
  home.sessionVariables.PROTON_PASS_LINUX_KEYRING = "dbus";

  services.proton-pass-agent.enable = true;

  systemd.user.services.proton-pass-agent.Service.Environment = [
    "PROTON_PASS_LINUX_KEYRING=dbus"
  ];

  systemd.user.services.proton-pass = {
    Unit = {
      Description = "Proton Pass desktop application";
      After = [ "graphical-session.target" ];
      PartOf = [ "graphical-session.target" ];
    };

    Service = {
      ExecStart = lib.getExe pkgs.proton-pass;
      Restart = "on-failure";
      RestartSec = 5;
    };

    Install.WantedBy = [ "graphical-session.target" ];
  };
}
