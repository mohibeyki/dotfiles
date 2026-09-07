{
  config,
  inputs,
  pkgs,
  ...
}:
let
  dmsPackage = inputs.dms.packages.${pkgs.stdenv.hostPlatform.system}.default;
  # The bundled greeter still uses the old dispatcher syntax. Keep the Lua
  # expression in a helper so it survives the launcher's shell/Lua quoting.
  exitGreeter = pkgs.writeShellScript "dms-greeter-exit-hyprland" ''
    exec ${config.programs.hyprland.package}/bin/hyprctl dispatch 'hl.dsp.exit()'
  '';
  greeterPackage = pkgs.symlinkJoin {
    name = "dms-greeter-hyprland-lua";
    paths = [ dmsPackage ];
    postBuild = ''
      unlink "$out/share/quickshell/dms/Modules/Greetd/assets/dms-greeter"
      substitute ${dmsPackage}/share/quickshell/dms/Modules/Greetd/assets/dms-greeter \
        "$out/share/quickshell/dms/Modules/Greetd/assets/dms-greeter" \
        --replace-fail 'hyprctl dispatch exit' '${exitGreeter}'
    '';
  };
in
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
      # Without this compatibility patch greetd waits for its five-second
      # timeout instead of the greeter compositor exiting after authentication.
      package = greeterPackage;
    };
  };

  # Preserve KDE Wallet unlock for Plasma sessions started through greetd.
  security.pam.services.greetd.kwallet.enable = true;
}
