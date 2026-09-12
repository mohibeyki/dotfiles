{
  config,
  pkgs,
  ...
}:
{
  services.displayManager = {
    # Both Hyprland and Plasma are registered by their respective NixOS modules.
    defaultSession = "hyprland-uwsm";
    dms-greeter = {
      enable = true;
      compositor = {
        name = "hyprland";
        customConfig = ''
          -- A greeter is not a desktop session: do not activate desktop targets
          -- or publish its short-lived display into its user service manager.
          hl.env("DMS_RUN_GREETER", "1")
          hl.env("HYPRLAND_NO_SD_VARS", "1")
          hl.env("HYPRLAND_NO_SD_TARGET", "1")
          hl.config({
            misc = { disable_hyprland_logo = true, disable_splash_rendering = true },
            xwayland = { enabled = false },
          })

          -- Use the same modes/scale as the desktop, avoiding a default 60 Hz
          -- greeter followed by another display-mode change on login.
          local host = dofile("${
            config.home-manager.users.mohi.xdg.configFile."hypr/generated-host.lua".source
          }")
          for _, monitor in ipairs(host.monitors) do
            hl.monitor(monitor)
          end
        '';
      };
      configHome = "/home/mohi";
      # The greeter is now packaged separately from the desktop shell and
      # already supports Hyprland's Lua exit dispatcher.
      package = pkgs.dms-greeter;
    };
  };

  # Preserve KDE Wallet unlock for Plasma sessions started through greetd.
  # Pin the Plasma 6 helper; the option default is the same package, but greetd
  # is the PAM service that actually runs at graphical login.
  security.pam.services.greetd.kwallet = {
    enable = true;
    package = pkgs.kdePackages.kwallet-pam;
  };
}
