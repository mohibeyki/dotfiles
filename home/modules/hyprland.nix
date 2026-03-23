{
  pkgs,
  hostConfig,
  lib,
  ...
}:
let
  monitors = map (monitor: {
    inherit (monitor)
      output
      mode
      position
      scale
      bitdepth
      ;
    vrr = if monitor.vrr then 1 else 0;
  }) (hostConfig.monitors or [ ]);

  workspaces = hostConfig.workspaces or [ ];

  primaryMonitor = hostConfig.primaryMonitor or null;
in
{
  wayland.windowManager.hyprland = {
    enable = true;
    package = null;
    portalPackage = null;
    settings = {
      monitorv2 = monitors;
      workspace = workspaces;

      bind = [
        # Noctalia launcher entrypoints.
        "SUPER, P, exec, noctalia-shell ipc call launcher toggle"
        "SUPER SHIFT, P, exec, noctalia-shell ipc call launcher command"

        # App launchers and Noctalia search modes.
        "SUPER, RETURN, exec, ghostty"
        "SUPER, B, exec, firefox"
        "SUPER, V, exec, noctalia-shell ipc call launcher clipboard"
        "SUPER, O, exec, noctalia-shell ipc call launcher windows"
        "SUPER, comma, exec, noctalia-shell ipc call launcher settings"
        "SUPER, period, exec, noctalia-shell ipc call launcher emoji"

        # Session and window management actions.
        "SUPER, Q, killactive"
        "SUPER CTRL, R, exec, hyprctl reload"
        "SUPER CTRL, escape, exec, loginctl lock-session"
        "SUPER, T, togglefloating"
        "SUPER, F, fullscreen, 0"
        "SUPER SHIFT, F, fullscreen, 1"
        "SUPER CTRL SHIFT, Q, exec, hyprctl activewindow | grep pid | tr -d 'pid:' | xargs kill"
        "SUPER SHIFT, D, layoutmsg, swapsplit"
        "SUPER SHIFT, S, layoutmsg, togglesplit"

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

      exec-once = [
        "${pkgs.hyprpolkitagent}/libexec/hyprpolkitagent"
      ]
      ++ lib.optional (
        primaryMonitor != null
      ) "hyprctl dispatch focusmonitor \"${primaryMonitor}\" && hyprctl dispatch workspace 2";

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
          scroll_factor = 1.0;
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
          new_optimizations = true;
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
        vrr = 0;
      };

      dwindle = {
        pseudotile = false;
        preserve_split = true;
      };

      layerrule = [
        "blur on, match:namespace logout_dialog"
        "no_anim on, match:namespace ^(selection)$"
      ];

      windowrule = [
        "tag +chromium-based-browser, match:class ([cC]hrom(e|ium)|[bB]rave-browser|Microsoft-edge|Vivaldi-stable)"
        "tag +firefox-based-browser, match:class ([fF]irefox|zen|librewolf)"
        "tag +terminal, match:class (Alacritty|kitty|com.mitchellh.ghostty)"
        "tag +floating-window, match:class (blueberry.py|Impala|com.github.tsowell.wiremix|org.gnome.NautilusPreviewer|com.gabm.satty|Omarchy|About|TUI.float)"
        "tag +floating-window, match:class (xdg-desktop-portal-gtk|sublime_text|DesktopEditors|org.gnome.Nautilus), match:title ^(Open.*Files?|Open [F|f]older.*|Save.*Files?|Save.*As|Save|All Files)"
        "tile on, match:tag chromium-based-browser"
        "float on, match:title ^(pavucontrol)$"
        "float on, match:title ^(blueman-manager)$"
        "float on, match:title ^(nm-connection-editor)$"
        "float on, match:title ^(Calculator)$"
        "float on, match:title ^(Picture-in-Picture)$"
        "pin on, match:title ^(Picture-in-Picture)$"
        "move 69.5% 4%, match:title ^(Picture-in-Picture)$"
        "idle_inhibit fullscreen, match:class ([window])"
        "float on, match:tag floating-window"
        "center on, match:tag floating-window"
        "size 800 600, match:tag floating-window"
        "fullscreen on, match:class Screensaver"
        "opacity 1 1, match:class ^(zoom|vlc|mpv|org.kde.kdenlive|com.obsproject.Studio|com.github.PintaProject.Pinta|imv|org.gnome.NautilusPreviewer)$"
      ];
    };
  };

  services.hyprpaper = {
    enable = true;
    settings = {
      ipc = "on";
      splash = false;
      preload = [ hostConfig.wallpaper ];
      wallpaper = {
        monitor = "";
        path = hostConfig.wallpaper;
        fit_mode = "fill";
      };
    };
  };

  programs.hyprlock = {
    enable = true;
    settings = {
      general = {
        disable_loading_bar = true;
        hide_cursor = true;
      };
    };
  };

  services.hypridle = {
    enable = true;
    settings = {
      general = {
        lock_cmd = "pidof hyprlock || hyprlock";
        before_sleep_cmd = "loginctl lock-session";
        after_sleep_cmd = "hyprctl dispatch dpmsoff && hyprctl dispatch dpmson";
      };
      listener = [
        {
          timeout = 900;
          on-timeout = "loginctl lock-session";
        }
      ];
    };
  };

  home.packages = with pkgs; [
    hyprpolkitagent
  ];
}
