{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (pkgs.stdenv.hostPlatform) isLinux;

  # Same path on Linux and macOS. On Mac, 1Password creates this socket (or a
  # symlink to its app-group container) when the SSH agent is enabled.
  agentSock = "${config.home.homeDirectory}/.1password/agent.sock";
in
{
  home.sessionVariables.SSH_AUTH_SOCK = agentSock;

  programs.ssh.settings."*" = {
    IdentityAgent = agentSock;
  };

  # Unlock the desktop app (and SSH agent) with the graphical session on NixOS.
  # WantedBy default.target (not graphical-session): DMS is After
  # graphical-session, and 1Password's Electron tray does not retry if the
  # StatusNotifier watcher is missing at startup.
  systemd.user.services."1password" = lib.mkIf isLinux {
    Unit = {
      Description = "1Password";
      After = [
        "graphical-session.target"
        "dms.service"
      ];
      PartOf = [ "graphical-session.target" ];
    };
    Service = {
      ExecStart = "${lib.getExe' pkgs._1password-gui "1password"} --silent";
      Restart = "on-failure";
      RestartSec = 5;
    };
    Install.WantedBy = [ "default.target" ];
  };
}
