{ lib, ... }: {
  programs.dank-material-shell = {
    enable = true;
    enableDynamicTheming = false;
    enableCalendarEvents = false;
    systemd = {
      enable = true;
      target = "wayland-session@hyprland.desktop.target";
    };

    # Keep DMS's appearance separate from the declarative Rosé Pine desktop theme.
    settings = {
      # Match the pinned DMS schema; otherwise this read-only file is migrated
      # from version 0 on every launch. A stock theme does not invoke matugen.
      configVersion = 17;
      currentThemeName = "purple";
    };
  };

  # The packaged unit waits for the same UWSM target that wants it, and waiting
  # for graphical-session.target closes a cycle through 1Password. systemd then
  # drops DMS on the first login. Wait only for the compositor and session env.
  systemd.user.services.dms.Unit.After = lib.mkForce [
    "wayland-wm@hyprland.desktop.service"
    "wayland-session-waitenv.service"
  ];
}
