{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (config.dotfiles) host;
  inherit (host) workspaces;

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
in
{
  xdg.portal = {
    enable = true;
    extraPortals = [
      pkgs.kdePackages.xdg-desktop-portal-kde
    ];

    config.hyprland.default = [
      "hyprland"
      "kde"
    ];
  };

  wayland.windowManager.hyprland = {
    enable = true;

    settings = {
      monitorv2 = monitors;
      workspace = workspaces;

      env = [
        "ELECTRON_OZONE_PLATFORM_HINT,auto"
        "NIXOS_OZONE_WL,1"
        "HYPRCURSOR_THEME,rose-pine-hyprcursor"
        "HYPRCURSOR_SIZE,24"
      ]
      ++ lib.optionals host.isNvidia [
        "LIBVA_DRIVER_NAME,nvidia"
        "__GLX_VENDOR_LIBRARY_NAME,nvidia"
        "NVD_BACKEND,direct"
      ];

      bind = [
        # Noctalia launcher entrypoints.
        "SUPER, P, exec, noctalia-shell ipc call launcher toggle"
        "SUPER SHIFT, P, exec, noctalia-shell ipc call launcher command"

        # App launchers and Noctalia search modes.
        "SUPER, RETURN, exec, ghostty"
        "SUPER, B, exec, brave"
        "SUPER, V, exec, noctalia-shell ipc call launcher clipboard"
        "SUPER, O, exec, noctalia-shell ipc call launcher windows"
        "SUPER, comma, exec, noctalia-shell ipc call launcher settings"
        "SUPER, period, exec, noctalia-shell ipc call launcher emoji"

        # Session and window management actions.
        "SUPER, Q, killactive"
        "SUPER CTRL, R, exec, hyprctl reload"
        "SUPER CTRL, escape, exec, noctalia-shell ipc call sessionMenu lock"
        "SUPER CTRL, Q, exec, noctalia-shell ipc call sessionMenu toggle"
        "SUPER, T, togglefloating"
        "SUPER, F, fullscreen, 0"
        "SUPER SHIFT, F, fullscreen, 1"
        "SUPER CTRL SHIFT, Q, exec, hyprctl -j activewindow | jq -e '.pid' | xargs -I{} kill -9 {}"
        "SUPER SHIFT, D, layoutmsg, swapsplit"
        "SUPER SHIFT, S, layoutmsg, togglesplit"

        # App shortcuts.
        "SUPER, E, exec, dolphin"
        "SUPER, S, exec, grimblast copy area"
        ", Print, exec, grimblast save area"

        # Media transport keys (must not repeat on hold).
        ", XF86AudioPlay, exec, noctalia-shell ipc call media playPause"
        ", XF86AudioPrev, exec, noctalia-shell ipc call media previous"
        ", XF86AudioNext, exec, noctalia-shell ipc call media next"

        # Focus movement with vim keys and arrows.
        "SUPER, H, movefocus, l"
        "SUPER, J, movefocus, d"
        "SUPER, K, movefocus, u"
        "SUPER, L, movefocus, r"
        "SUPER, left, movefocus, l"
        "SUPER, down, movefocus, d"
        "SUPER, up, movefocus, u"
        "SUPER, right, movefocus, r"

        # Move the active window around the layout.
        "SUPER CTRL, H, movewindow, l"
        "SUPER CTRL, J, movewindow, d"
        "SUPER CTRL, K, movewindow, u"
        "SUPER CTRL, L, movewindow, r"
        "SUPER CTRL, left, movewindow, l"
        "SUPER CTRL, down, movewindow, d"
        "SUPER CTRL, up, movewindow, u"
        "SUPER CTRL, right, movewindow, r"

        # Resize the active window.
        "SUPER SHIFT, H, resizeactive, -100 0"
        "SUPER SHIFT, J, resizeactive, 0 100"
        "SUPER SHIFT, K, resizeactive, 0 -100"
        "SUPER SHIFT, L, resizeactive, 100 0"
        "SUPER SHIFT, left, resizeactive, -100 0"
        "SUPER SHIFT, down, resizeactive, 0 100"
        "SUPER SHIFT, up, resizeactive, 0 -100"
        "SUPER SHIFT, right, resizeactive, 100 0"

        # Swap windows and move them across monitors.
        "SUPER ALT, H, swapwindow, l"
        "SUPER ALT, J, swapwindow, d"
        "SUPER ALT, K, swapwindow, u"
        "SUPER ALT, L, swapwindow, r"
        "SUPER ALT, left, swapwindow, l"
        "SUPER ALT, down, swapwindow, d"
        "SUPER ALT, up, swapwindow, u"
        "SUPER ALT, right, swapwindow, r"

        # Scratchpad workspace for temporary windows.
        "SUPER, grave, togglespecialworkspace, magic"
        "SUPER SHIFT, grave, movetoworkspace, special:magic"

        # Workspace switching and sending windows to workspaces.
        "SUPER, TAB, workspace, m+1"
        "SUPER SHIFT, TAB, workspace, m-1"
        "SUPER SHIFT, 1, movetoworkspace, 1"
        "SUPER SHIFT, 2, movetoworkspace, 2"
        "SUPER SHIFT, 3, movetoworkspace, 3"
        "SUPER SHIFT, 4, movetoworkspace, 4"
        "SUPER SHIFT, 5, movetoworkspace, 5"
        "SUPER SHIFT, 6, movetoworkspace, 6"
        "SUPER SHIFT, 7, movetoworkspace, 7"
        "SUPER SHIFT, 8, movetoworkspace, 8"
        "SUPER SHIFT, 9, movetoworkspace, 9"
        "SUPER SHIFT, 0, movetoworkspace, 10"
        "SUPER, 1, workspace, 1"
        "SUPER, 2, workspace, 2"
        "SUPER, 3, workspace, 3"
        "SUPER, 4, workspace, 4"
        "SUPER, 5, workspace, 5"
        "SUPER, 6, workspace, 6"
        "SUPER, 7, workspace, 7"
        "SUPER, 8, workspace, 8"
        "SUPER, 9, workspace, 9"
        "SUPER, 0, workspace, 10"
      ];

      bindel = [
        # Volume keys (repeat on hold is desirable).
        ", XF86AudioRaiseVolume, exec, noctalia-shell ipc call volume increase"
        ", XF86AudioLowerVolume, exec, noctalia-shell ipc call volume decrease"
        ", XF86AudioMute, exec, noctalia-shell ipc call volume mute"
      ];

      bindm = [
        "SUPER, mouse:272, movewindow"
        "SUPER, mouse:273, resizewindow"
      ];

      exec-once = [
        "${pkgs.kdePackages.kwallet-pam}/libexec/pam_kwallet_init"
        "${pkgs.kdePackages.kservice}/bin/kbuildsycoca6"
        "${pkgs.kdePackages.polkit-kde-agent-1}/libexec/polkit-kde-authentication-agent-1"
        "env -u QT_QPA_PLATFORMTHEME noctalia-shell"
        "${pkgs._1password-gui}/bin/1password --silent"
      ];

      general = {
        border_size = 0;
        gaps_in = 8;
        gaps_out = 8;
        layout = "dwindle";
      };

      input = {
        kb_layout = "us";
        kb_options = "altwin:swap_lalt_lwin";
        numlock_by_default = true;
        follow_mouse = 1;
        mouse_refocus = false;
        sensitivity = -0.2;
        accel_profile = "flat";

        touchpad = {
          natural_scroll = true;
        };
      };

      decoration = {
        rounding = 8;
        active_opacity = 1.0;
        inactive_opacity = 0.9;
        fullscreen_opacity = 1.0;

        blur = {
          enabled = true;
          size = 16;
          passes = 4;
          ignore_opacity = true;
          xray = false;
        };

        shadow = {
          enabled = true;
          range = 16;
          render_power = 3;
          color = "0xee1a1a1a";
        };
      };

      animations = {
        enabled = true;
        animation = [
          "global, 1, 4, default"
          "windows, 1, 4, default, popin 60%"
          "workspaces, 1, 4, default, slide"
        ];
      };

      misc = {
        disable_hyprland_logo = true;
        disable_splash_rendering = true;
        font_family = "JetBrainsMono Nerd Font";
      };

      dwindle = {
        preserve_split = true;
      };

    };
  };

}
