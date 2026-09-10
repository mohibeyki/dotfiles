{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (config.dotfiles) host;
  inherit (host) workspaces;

  luaString = value: builtins.toJSON value;

  monitors = map (
    monitor:
    lib.filterAttrs (_: value: value != null) {
      inherit (monitor)
        output
        mode
        position
        scale
        bitdepth
        vrr
        cm
        icc
        ;
    }
  ) host.monitors;

  monitorToLua = monitor: ''
    {
      output = ${luaString monitor.output},
      mode = ${luaString monitor.mode},
      position = ${luaString monitor.position},
      scale = ${luaString monitor.scale},
      bitdepth = ${toString monitor.bitdepth},
      vrr = ${toString monitor.vrr},
    ${lib.optionalString (monitor ? cm) "  cm = ${luaString monitor.cm},"}
    ${lib.optionalString (monitor ? icc) "  icc = ${luaString monitor.icc},"}
    },'';

  env = [
    [
      "ELECTRON_OZONE_PLATFORM_HINT"
      "auto"
    ]
    [
      "NIXOS_OZONE_WL"
      "1"
    ]
    [
      "HYPRCURSOR_THEME"
      "rose-pine-hyprcursor"
    ]
    [
      "HYPRCURSOR_SIZE"
      "24"
    ]
  ]
  ++ lib.optionals host.isNvidia [
    [
      "LIBVA_DRIVER_NAME"
      "nvidia"
    ]
    [
      "__GLX_VENDOR_LIBRARY_NAME"
      "nvidia"
    ]
    [
      "NVD_BACKEND"
      "direct"
    ]
  ];

  envToShell =
    entry: "export ${builtins.elemAt entry 0}=${lib.escapeShellArg (builtins.elemAt entry 1)}";

  workspaceToLua = workspace: ''
    {
      id = ${luaString workspace.id},
      monitor = ${luaString workspace.monitor},
      default = ${if workspace.default then "true" else "false"},
      persistent = ${if workspace.persistent then "true" else "false"},
    },'';

  bindsLua = builtins.readFile ./hypr/binds.lua + "\n" + builtins.readFile ./hypr/binds-dms.lua;

  secondaryMonitor = lib.findFirst (
    monitor: monitor.output == "desc:ASUSTek COMPUTER INC XG32UCDS W3LMQV042954"
  ) (throw "The configured secondary monitor is missing from dotfiles.host.monitors") host.monitors;

  secondaryMonitorToLua = monitor: ''
    {
      output = ${luaString monitor.output},
      mode = ${luaString monitor.mode},
      position = ${luaString monitor.position},
      scale = ${luaString monitor.scale},
      bitdepth = ${toString monitor.bitdepth},
      vrr = ${toString monitor.vrr},
      ${lib.optionalString (monitor.cm != null) "cm = ${luaString monitor.cm},"}
      ${lib.optionalString (monitor.icc != null) "icc = ${luaString monitor.icc},"}
      disabled = false,
    }
  '';

  toggleSecondaryMonitor = pkgs.writeShellScriptBin "toggle-secondary-monitor" ''
    set -eu

    state_file="''${XDG_RUNTIME_DIR}/hypr-secondary-monitor.disabled"
    if [ -e "$state_file" ]; then
      result="$(hyprctl eval 'hl.monitor(${secondaryMonitorToLua secondaryMonitor})')"
      case "$result" in
        ok*) rm -f "$state_file"; printf '%s\n' "Secondary monitor enabled" ;;
        *) printf '%s\n' "$result" >&2; exit 1 ;;
      esac
    else
      result="$(hyprctl eval 'hl.monitor({ output = ${luaString secondaryMonitor.output}, disabled = true })')"
      case "$result" in
        ok*) : > "$state_file"; printf '%s\n' "Secondary monitor disabled" ;;
        *) printf '%s\n' "$result" >&2; exit 1 ;;
      esac
    fi
  '';

in
{
  xdg.configFile = {
    # UWSM exports these before starting the compositor and removes them when
    # the session ends. Lua-only env vars do not reliably reach systemd apps.
    "uwsm/env-hyprland".text = ''
      ${lib.concatStringsSep "\n" (map envToShell env)}
      export HYPRLAND_NO_SD_VARS=1
      export HYPRLAND_NO_SD_TARGET=1
    '';
    "hypr/hyprland.lua".source = ./hypr/hyprland.lua;
    "hypr/binds.lua".text = bindsLua;
    "hypr/host.lua".source = ./hypr/host.lua;
    "hypr/rules.lua".source = ./hypr/rules.lua;
    "hypr/settings.lua".source = ./hypr/settings.lua;

    "hypr/generated-host.lua".text = ''
      return {
        monitors = {
      ${lib.concatStringsSep "\n" (map monitorToLua monitors)}
        },

        workspaces = {
      ${lib.concatStringsSep "\n" (map workspaceToLua workspaces)}
        },
      }
    '';
  };

  # NixOS programs.hyprland + UWSM owns the compositor binary and session.
  # Home Manager only materializes config (Lua under xdg.configFile above).
  wayland.windowManager.hyprland = {
    enable = true;
    package = null;
    portalPackage = null;
    systemd.enable = false;
    configType = "lua";
  };

  home.file = {
    "Pictures/face.png".source = ../../assets/face.png;
    "Pictures/Wallpapers/wallpaper.jpg".source = ../../assets/wallpaper.jpg;
  };

  home.packages = [ toggleSecondaryMonitor ];
}
