{
  inputs,
  pkgs,
  hostConfig,
  lib,
  config,
  ...
}:
let
  monitorLines = builtins.concatStringsSep "\n" (
    map (monitor: ''
      monitorv2 {
          output = ${monitor.output}
          mode = ${monitor.mode}
          position = ${monitor.position}
          scale = ${toString monitor.scale}
          bitdepth = ${toString monitor.bitdepth}
          vrr = ${if monitor.vrr then "1" else "0"}
      }
    '') (hostConfig.monitors or [ ])
  );
  workspaceLines = builtins.concatStringsSep "\n" (
    map (workspace: "workspace = ${workspace}") (hostConfig.workspaces or [ ])
  );
  hyprVarsConfig = ''
    $touchpadScrollFactor = 1.0
    $blurSize = 16
    $blurPasses = 4
    $shadowRange = 16
    $workspaceGaps = 20
    $windowGapsIn = 10
    $windowGapsOut = 40
    $singleWindowGapsOut = 8
    $windowOpacity = 1.0
    $windowRounding = 8
    $windowBorderSize = 0
  '';
  hyprUserConfig = ''
    unbind = Super, Super_L
    unbind = Super Shift, S
    unbind = Super, catchall

    bind = SUPER      , RETURN, exec, ghostty
    bind = SUPER      , B     , exec, firefox
    bind = SUPER CTRL , R     , exec, hyprctl reload
    bind = SUPER      , T     , togglefloating
    bind = SUPER      , F     , fullscreen, 0
    bind = SUPER SHIFT, F     , fullscreen, 1
    bind = SUPER SHIFT, Q     , exec, hyprctl activewindow | grep pid | tr -d 'pid:' | xargs kill
    bind = SUPER SHIFT, D     , layoutmsg, swapsplit
    bind = SUPER SHIFT, S     , layoutmsg, togglesplit
    bind = SUPER      , H     , movefocus, l
    bind = SUPER      , J     , movefocus, d
    bind = SUPER SHIFT, H     , resizeactive, -100 0
    bind = SUPER SHIFT, J     , resizeactive, 0 100
    bind = SUPER SHIFT, K     , resizeactive, 0 -100
    bind = SUPER SHIFT, L     , resizeactive, 100 0
    bind = SUPER ALT  , H     , swapwindow, l
    bind = SUPER ALT  , J     , swapwindow, d
    bind = SUPER ALT  , K     , swapwindow, u
    bind = SUPER ALT  , L     , swapwindow, r

    bind = SUPER      , TAB, workspace, m+1
    bind = SUPER SHIFT, TAB, workspace, m-1
    bind = SUPER SHIFT, 1, movetoworkspace, 1
    bind = SUPER SHIFT, 2, movetoworkspace, 2
    bind = SUPER SHIFT, 3, movetoworkspace, 3
    bind = SUPER SHIFT, 4, movetoworkspace, 4
    bind = SUPER SHIFT, 5, movetoworkspace, 5
    bind = SUPER SHIFT, 6, movetoworkspace, 6
    bind = SUPER SHIFT, 7, movetoworkspace, 7
    bind = SUPER SHIFT, 8, movetoworkspace, 8
    bind = SUPER SHIFT, 9, movetoworkspace, 9
    bind = SUPER SHIFT, 0, movetoworkspace, 10

    bind = SUPER, 1, workspace, 1
    bind = SUPER, 2, workspace, 2
    bind = SUPER, 3, workspace, 3
    bind = SUPER, 4, workspace, 4
    bind = SUPER, 5, workspace, 5
    bind = SUPER, 6, workspace, 6
    bind = SUPER, 7, workspace, 7
    bind = SUPER, 8, workspace, 8
    bind = SUPER, 9, workspace, 9
    bind = SUPER, 0, workspace, 10

    exec-once = ${pkgs.hyprpolkitagent}/libexec/hyprpolkitagent
    exec-once = hyprctl dispatch focusmonitor "${hostConfig.primaryMonitor}" && hyprctl dispatch workspace 2

    general {
        border_size = 0
        gaps_in = 8
        gaps_out = 8
        layout = dwindle
    }

    input {
        kb_layout = us
        kb_options = altwin:swap_lalt_lwin
        numlock_by_default = true
        follow_mouse = 1
        mouse_refocus = false
        sensitivity = -0.2
        accel_profile = flat

        touchpad {
            natural_scroll = true
            scroll_factor = 1.0
        }
    }

    decoration {
        rounding = 8
        active_opacity = 1.0
        inactive_opacity = 0.9
        fullscreen_opacity = 1.0

        blur {
            enabled = true
            size = 16
            passes = 4
            ignore_opacity = true
            new_optimizations = true
            xray = false
        }

        shadow {
            enabled = true
            range = 16
            render_power = 3
            color = 0xee1a1a1a
        }
    }

    animations {
        enabled = true

        animation = global    , 1, 4, default
        animation = windows   , 1, 4, default, popin 60%
        animation = workspaces, 1, 4, default, slide
    }

    misc {
        disable_hyprland_logo = true
        disable_splash_rendering = true
        font_family = JetBrainsMono Nerd Font
        vrr = 0
    }

    dwindle {
        pseudotile = false
        preserve_split = true
    }

    layerrule = blur on, match:namespace logout_dialog
    layerrule = no_anim on, match:namespace ^(selection)$

    windowrule = tag +chromium-based-browser, match:class ([cC]hrom(e|ium)|[bB]rave-browser|Microsoft-edge|Vivaldi-stable)
    windowrule = tag +firefox-based-browser, match:class ([fF]irefox|zen|librewolf)
    windowrule = tag +terminal, match:class (Alacritty|kitty|com.mitchellh.ghostty)
    windowrule = tag +floating-window, match:class (blueberry.py|Impala|com.github.tsowell.wiremix|org.gnome.NautilusPreviewer|com.gabm.satty|Omarchy|About|TUI.float)
    windowrule = tag +floating-window, match:class (xdg-desktop-portal-gtk|sublime_text|DesktopEditors|org.gnome.Nautilus), match:title ^(Open.*Files?|Open [F|f]older.*|Save.*Files?|Save.*As|Save|All Files)
    windowrule = tile on, match:tag chromium-based-browser
    windowrule = float on, match:title ^(pavucontrol)$
    windowrule = float on, match:title ^(blueman-manager)$
    windowrule = float on, match:title ^(nm-connection-editor)$
    windowrule = float on, match:title ^(Calculator)$
    windowrule = float on, match:title ^(Picture-in-Picture)$
    windowrule = pin on, match:title ^(Picture-in-Picture)$
    windowrule = move 69.5% 4%, match:title ^(Picture-in-Picture)$
    windowrule = idle_inhibit fullscreen, match:class ([window])
    windowrule = float on, match:tag floating-window
    windowrule = center on, match:tag floating-window
    windowrule = size 800 600, match:tag floating-window
    windowrule = fullscreen on, match:class Screensaver
    windowrule = opacity 1 1, match:class ^(zoom|vlc|mpv|org.kde.kdenlive|com.obsproject.Studio|com.github.PintaProject.Pinta|imv|org.gnome.NautilusPreviewer)$
  ''
  + (if monitorLines == "" then "" else "\n${monitorLines}\n")
  + (if workspaceLines == "" then "" else "\n${workspaceLines}\n");
in
{
  xdg.configFile = {
    "hypr/hyprland.conf".text = ''
      # Hyprland user configuration
      # This file sources hypr-vars.conf and hypr-user.conf
    '';
    "hypr/hypr-vars.conf".text = hyprVarsConfig;
    "hypr/hypr-user.conf".text = hyprUserConfig;
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
