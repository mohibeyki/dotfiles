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

  # Render a monitor as a Lua table. `extra` is appended verbatim (e.g. `disabled = false,`).
  monitorToLua =
    extra: monitor:
    let
      field = name: value: "  ${name} = ${value},";
      optional =
        name: lib.optional (monitor.${name} or null != null) (field name (luaString monitor.${name}));
    in
    lib.concatStringsSep "\n" (
      [ "{" ]
      ++ [
        (field "output" (luaString monitor.output))
        (field "mode" (luaString monitor.mode))
        (field "position" (luaString monitor.position))
        (field "scale" (luaString monitor.scale))
        (field "bitdepth" (toString monitor.bitdepth))
        (field "vrr" (toString monitor.vrr))
      ]
      ++ optional "cm"
      ++ optional "icc"
      ++ lib.optional (extra != "") "  ${extra}"
      ++ [ "}" ]
    );

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

  toggleSecondaryMonitor = pkgs.writeShellScriptBin "toggle-secondary-monitor" ''
    set -eu

    state_dir="''${XDG_STATE_HOME:-$HOME/.local/state}/hypr"
    mkdir -p "$state_dir"

    monitors="$(hyprctl -j monitors)"
    active="$(printf '%s\n' "$monitors" | ${lib.getExe pkgs.jq} \
      --arg description ${lib.escapeShellArg (lib.removePrefix "desc:" secondaryMonitor.output)} \
      'any(.[]; .description == $description and (.disabled != true))')"

    if [ "$active" = true ]; then
      result="$(hyprctl eval 'hl.monitor({ output = ${luaString secondaryMonitor.output}, disabled = true })')"
      case "$result" in
        ok*) printf '%s\n' disabled > "$state_dir/secondary-monitor"
             printf '%s\n' "Secondary monitor disabled" ;;
        *) printf '%s\n' "$result" >&2; exit 1 ;;
      esac
    else
      result="$(hyprctl eval 'hl.monitor(${monitorToLua "disabled = false," secondaryMonitor})')"
      case "$result" in
        ok*) printf '%s\n' enabled > "$state_dir/secondary-monitor"
             printf '%s\n' "Secondary monitor enabled" ;;
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
        secondaryMonitorOutput = ${luaString secondaryMonitor.output},

        monitors = {
      ${lib.concatStringsSep "\n" (map (m: "${monitorToLua "" m},") host.monitors)}
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
