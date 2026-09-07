_: {
  programs.dank-material-shell = {
    enable = true;
    enableDynamicTheming = false;
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

  # The UWSM compositor target precedes graphical-session.target. Wait for
  # waitenv to finish as well, without enabling DMS in Plasma sessions.
  systemd.user.services.dms.Unit.After = [ "graphical-session.target" ];
}
