{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (pkgs.stdenv.hostPlatform) isDarwin isLinux;

  # macOS does not create the optional ~/.1password/agent.sock symlink.
  agentSock =
    if isDarwin then
      "${config.home.homeDirectory}/Library/Group Containers/2BUA8C4S2C.com.1password/t/agent.sock"
    else
      "${config.home.homeDirectory}/.1password/agent.sock";
in
{
  # IdentityAgent covers outbound ssh/git. Do not export SSH_AUTH_SOCK when
  # sshd has already forwarded an agent (SSH_CONNECTION is set).
  programs = {
    ssh.settings = {
      # SSH uses the first matching value; retain a forwarded agent before
      # applying the local 1Password fallback (including for GUI clients).
      forwarded-agent = lib.hm.dag.entryBefore [ "*" ] {
        header = ''Match exec "test -n \"$SSH_CONNECTION\""'';
        IdentityAgent = "SSH_AUTH_SOCK";
      };
      "*".IdentityAgent = ''"${agentSock}"'';
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

    zsh.initContent = ''
      if [ -z "''${SSH_CONNECTION-}" ]; then
        export SSH_AUTH_SOCK="${agentSock}"
      fi
    '';
  };

  systemd.user.sessionVariables = lib.mkIf isLinux {
    SSH_AUTH_SOCK = agentSock;
  };

  # Start in the Hyprland UWSM session, after DMS creates the StatusNotifier
  # watcher. Electron does not retry the tray if it launches first. Do not also
  # order this service after graphical-session.target: that target is ordered
  # after the UWSM session, so doing both creates a startup cycle and systemd
  # drops this service.
  #
  # A rebuild can replace the install path while 1Password is running. It then
  # exits 0, which Restart=on-failure ignores. Turn only that exit into a failure.
  systemd.user.services."1password" = lib.mkIf isLinux {
    Unit = {
      Description = "1Password";
      After = [ "dms.service" ];
      PartOf = [ "dms.service" ];
    };
    Service = {
      ExecStart = pkgs.writeShellScript "1password-start" ''
        log="$HOME/.config/1Password/logs/1Password_rCURRENT.log"
        ${lib.getExe' pkgs._1password-gui "1password"} --silent
        status=$?
        if [ "$status" -eq 0 ] && [ -f "$log" ] && tail -n 8 "$log" | grep -q "moved or replaced, exiting"; then
          exit 1
        fi
        exit "$status"
      '';
      Restart = "on-failure";
      RestartSec = 2;
    };
    Install.WantedBy = [ "wayland-session@hyprland.desktop.target" ];
  };
}
