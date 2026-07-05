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

  envToLua =
    entry: "{ ${luaString (builtins.elemAt entry 0)}, ${luaString (builtins.elemAt entry 1)} },";

  bindsLua =
    let
      baseBinds = builtins.readFile ./hypr/binds.lua;
      noctaliaBinds = builtins.readFile ./hypr/binds-noctalia.lua;
    in
    if host.shell == "noctalia" then baseBinds + "\n" + noctaliaBinds else baseBinds;

  shellStartupLine =
    if host.shell == "noctalia" then
      ''hl.dispatch(hl.dsp.exec_cmd("env -u QT_QPA_PLATFORMTHEME noctalia"))''
    else
      "";
in
{
  xdg.portal = {
    enable = true;
    extraPortals = [
      pkgs.kdePackages.xdg-desktop-portal-kde
    ];

    config = {
      hyprland.default = [
        "hyprland"
        "kde"
      ];
    };
  };

  xdg.configFile = {
    "hypr/hyprland.lua".source = ./hypr/hyprland.lua;
    "hypr/binds.lua".text = bindsLua;
    "hypr/host.lua".source = ./hypr/host.lua;
    "hypr/rules.lua".source = ./hypr/rules.lua;
    "hypr/settings.lua".source = pkgs.replaceVars ./hypr/settings.lua {
      blueman = "${pkgs.blueman}";
      kservice = "${pkgs.kdePackages.kservice}";
      onePassword = "${pkgs._1password-gui}";
      polkitKde = "${pkgs.kdePackages.polkit-kde-agent-1}";
      shellStartup = shellStartupLine;
    };

    "hypr/generated-host.lua".text = ''
      return {
        monitors = {
      ${lib.concatStringsSep "\n" (map monitorToLua monitors)}
        },

        workspaces = {
      ${lib.concatStringsSep "\n" (map (workspace: "    ${luaString workspace},") workspaces)}
        },

        env = {
      ${lib.concatStringsSep "\n" (map envToLua env)}
        },
      }
    '';
  };

  wayland.windowManager.hyprland = {
    enable = true;
    extraConfig = "# Hyprland v0.55 reads ~/.config/hypr/hyprland.lua.";
  };

  home.file = {
    "Pictures/face.png".source = ../../assets/face.png;
    "Pictures/Wallpapers/wallpaper.jpg".source = ../../assets/wallpaper.jpg;
  };
}
