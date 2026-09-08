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
  # IdentityAgent covers outbound ssh/git. Do not export SSH_AUTH_SOCK when
  # sshd has already forwarded an agent (SSH_CONNECTION is set).
  programs = {
    ssh.settings."*" = {
      IdentityAgent = agentSock;
    };

    fish.shellInit = ''
      if not set -q SSH_CONNECTION
        set -gx SSH_AUTH_SOCK "${agentSock}"
      end
    '';

    bash.initExtra = ''
      if [ -z "''${SSH_CONNECTION-}" ]; then
        export SSH_AUTH_SOCK="${agentSock}"
      fi
    '';

    zsh.initExtra = ''
      if [ -z "''${SSH_CONNECTION-}" ]; then
        export SSH_AUTH_SOCK="${agentSock}"
      fi
    '';
  };

  systemd.user.sessionVariables = lib.mkIf isLinux {
    SSH_AUTH_SOCK = agentSock;
  };

  # Start after DMS so the StatusNotifier watcher exists. Electron does not
  # retry the tray if it launches first. WantedBy dms.service (not
  # default.target or graphical-session): After= only orders units in the same
  # transaction, and SSH/TTY logins must not spawn the GUI.
  systemd.user.services."1password" = lib.mkIf isLinux {
    Unit = {
      Description = "1Password";
      After = [
        "graphical-session.target"
        "dms.service"
      ];
      PartOf = [
        "graphical-session.target"
        "dms.service"
      ];
    };
    Service = {
      ExecStart = "${lib.getExe' pkgs._1password-gui "1password"} --silent";
      Restart = "on-failure";
      RestartSec = 5;
    };
    Install.WantedBy = [ "dms.service" ];
  };
}
