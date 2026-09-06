{
  lib,
  pkgs,
  ...
}:
let
  isLinux = pkgs.stdenv.hostPlatform.isLinux;
in
{
  services.proton-pass-agent = {
    enable = true;
    socket = "proton-pass-agent";
    extraArgs = [
      "--vault-name"
      "Personal"
      "--refresh-interval"
      "300"
    ];
  };

  home.sessionVariables = lib.mkIf isLinux {
    PROTON_PASS_LINUX_KEYRING = "dbus";
  };

  systemd.user.services = lib.optionalAttrs isLinux {
    proton-pass-agent = {
      Unit = {
        After = [ "graphical-session.target" ];
        Wants = [ "graphical-session.target" ];
      };

      Service = {
        Environment = [ "PROTON_PASS_LINUX_KEYRING=dbus" ];
        RestartSec = 15;
      };
    };
  };
}
