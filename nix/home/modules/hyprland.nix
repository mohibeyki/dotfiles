{ ... }:
{
  imports = [
    ./mako.nix
    ./waybar.nix
    ./wlogout.nix
    ./wofi.nix
    ./theme.nix
  ];

  wayland.windowManager.hyprland = {
    enable = true;
    systemd.enable = true;
    xwayland.enable = true;

    settings = {
      # Variables
      "$mod" = "SUPER";

      # General
      general = {
        gaps_in = 8;
        gaps_out = 8;
        layout = "dwindle";
        border_size = 0;
      };

      # Environment variables
      env = [
        "XDG_CURRENT_DESKTOP,Hyprland"
        "XDG_SESSION_TYPE,wayland"
        "XDG_SESSION_DESKTOP,Hyprland"
        "GBM_BACKEND,nvidia-drm"
        "__GLX_VENDOR_LIBRARY_NAME,nvidia"
        "LIBVA_DRIVER_NAME,nvidia"
        "NVD_BACKEND,direct"
        "ELECTRON_OZONE_PLATFORM_HINT,auto"
        "SDL_VIDEODRIVER,wayland"
        "GDK_SCALE,1"
      ];

      # Monitor configuration
      monitor = [
        "DP-1, 2560x1440@180, -2560x0, 1, bitdepth, 10"
        "DP-2, 3840x2160@240,     0x0, 1, bitdepth, 10"
      ];

      # Cursor
      cursor = {
        no_hardware_cursors = true;
      };

      # Exec on startup
      exec-once = [
        "wl-paste --type text --watch cliphist store"
        "wl-paste --type image --watch cliphist store"
        "nm-applet"
        "waybar"
        "hyprpaper"
      ];

      # Misc
      misc = {
        disable_hyprland_logo = true;
        disable_splash_rendering = true;
        vrr = 1;
        key_press_enables_dpms = true;
      };

      # Layer rules
      layerrule = [
        # "blur, waybar"
        # "ignorezero, waybar"
        # "blur, wofi"
        # "ignorezero, wofi"
        # "blur, logout_dialog"
        # "ignorezero, logout_dialog"
        # "noanim, ^(selection)$"
      ];

      # Animations
      animations = {
        enabled = true;

        bezier = [
          "linear, 0, 0, 1, 1"
          "md3_standard, 0.2, 0, 0, 1"
          "md3_decel, 0.05, 0.7, 0.1, 1"
          "md3_accel, 0.3, 0, 0.8, 0.15"
          "overshot, 0.05, 0.9, 0.1, 1.1"
          "crazyshot, 0.1, 1.5, 0.76, 0.92"
          "hyprnostretch, 0.05, 0.9, 0.1, 1.0"
          "fluent_decel, 0.1, 1, 0, 1"
          "easeInOutCirc, 0.85, 0, 0.15, 1"
          "easeOutCirc, 0, 0.55, 0.45, 1"
          "easeOutExpo, 0.16, 1, 0.3, 1"
        ];

        animation = [
          "windows, 1, 3, md3_decel, popin 60%"
          "border, 1, 10, default"
          "fade, 1, 2.5, md3_decel"
          "workspaces, 1, 3.5, easeOutExpo, slide"
          "specialWorkspace, 1, 3, md3_decel, slidevert"
        ];
      };

      # Decorations
      decoration = {
        rounding = 8;
        active_opacity = 1.0;
        inactive_opacity = 0.9;
        fullscreen_opacity = 1.0;

        blur = {
          enabled = true;
          size = 16;
          passes = 4;
          new_optimizations = true;
          ignore_opacity = true;
          xray = false;
        };

        shadow = {
          enabled = true;
          range = 30;
          render_power = 3;
          color = "0x66000000";
        };
      };

      # Input
      input = {
        kb_layout = "us";
        kb_options = "altwin:swap_lalt_lwin";
        numlock_by_default = true;
        follow_mouse = 1;
        mouse_refocus = false;
        touchpad = {
          natural_scroll = false;
          scroll_factor = 1.0;
        };
        sensitivity = -0.2;
        accel_profile = "flat";
      };

      # Layout
      dwindle = {
        pseudotile = true;
        preserve_split = true;
      };

      binds = {
        workspace_back_and_forth = true;
        allow_workspace_cycles = true;
        pass_mouse_when_bound = false;
      };

      # Workspaces
      workspace = [
        "1, monitor:DP-1"
        "2, monitor:DP-2"
        "3, monitor:DP-1"
        "4, monitor:DP-2"
        "5, monitor:DP-1"
        "6, monitor:DP-2"
        "7, monitor:DP-1"
        "8, monitor:DP-2"
        "9, monitor:DP-1"
        "10, monitor:DP-2"
      ];

      # Window rules
      windowrule = [
        # "tag +chromium-based-browser, class:([cC]hrom(e|ium)|[bB]rave-browser|Microsoft-edge|Vivaldi-stable)"
        # "tag +firefox-based-browser, class:([fF]irefox|zen|librewolf)"
        # "tile, tag:chromium-based-browser"
        # "float, title:^(pavucontrol)$"
        # "float, title:^(blueman-manager)$"
        # "float, title:^(nm-connection-editor)$"
        # "float, title:^(Calculator)$"
        # "float, title:^(Picture-in-Picture)$"
        # "pin, title:^(Picture-in-Picture)$"
        # "move 69.5% 4%, title:^(Picture-in-Picture)$"
        # "idleinhibit fullscreen,class:([window])"
        # "float, tag:floating-window"
        # "center, tag:floating-window"
        # "size 800 600, tag:floating-window"
        # "tag +floating-window, class:(blueberry.py|Impala|com.github.tsowell.wiremix|org.gnome.NautilusPreviewer|com.gabm.satty|Omarchy|About|TUI.float)"
        # "tag +floating-window, class:(xdg-desktop-portal-gtk|sublime_text|DesktopEditors|org.gnome.Nautilus), title:^(Open.*Files?|Open [F|f]older.*|Save.*Files?|Save.*As|Save|All Files)"
        # "fullscreen, class:Screensaver"
        # "opacity 1 1, class:^(zoom|vlc|mpv|org.kde.kdenlive|com.obsproject.Studio|com.github.PintaProject.Pinta|imv|org.gnome.NautilusPreviewer)$"
        # "tag +terminal, class:(Alacritty|kitty|com.mitchellh.ghostty)"
      ];

      # Key bindings
      bind = [
        "$mod, RETURN, exec, ghostty"
        "$mod, B, exec, brave"
        "$mod, E, exec, nautilus"
        "$mod, Q, killactive"
        "$mod SHIFT, Q, exec, hyprctl activewindow | grep pid | tr -d 'pid:' | xargs kill"
        "$mod, F, fullscreen, 0"
        "$mod, M, fullscreen, 1"
        "$mod, T, togglefloating"
        "$mod SHIFT, T, workspaceopt, allfloat"
        "$mod, S, togglesplit"
        "$mod SHIFT, D, swapsplit"
        "$mod, left, movefocus, l"
        "$mod, right, movefocus, r"
        "$mod, up, movefocus, u"
        "$mod, down, movefocus, d"
        "$mod, H, movefocus, l"
        "$mod, L, movefocus, r"
        "$mod, K, movefocus, u"
        "$mod, J, movefocus, d"
        "$mod SHIFT, right, resizeactive, 100 0"
        "$mod SHIFT, left, resizeactive, -100 0"
        "$mod SHIFT, down, resizeactive, 0 100"
        "$mod SHIFT, up, resizeactive, 0 -100"
        "$mod, G, togglegroup"
        "$mod ALT, left, swapwindow, l"
        "$mod ALT, right, swapwindow, r"
        "$mod ALT, up, swapwindow, u"
        "$mod ALT, down, swapwindow, d"
        "$mod, P, exec, wofi --show drun"
        "$mod CTRL, R, exec, hyprctl reload"
        "$mod CTRL, Q, exec, wlogout -b 6 --protocol layer-shell"
        "$mod, V, exec, cliphist list | wofi --dmenu | cliphist decode | wl-copy"
        "$mod CTRL, L, exec, hyprlock"
        "$mod, 1, workspace, 1"
        "$mod, 2, workspace, 2"
        "$mod, 3, workspace, 3"
        "$mod, 4, workspace, 4"
        "$mod, 5, workspace, 5"
        "$mod, 6, workspace, 6"
        "$mod, 7, workspace, 7"
        "$mod, 8, workspace, 8"
        "$mod, 9, workspace, 9"
        "$mod, 0, workspace, 10"
        "$mod SHIFT, 1, movetoworkspace, 1"
        "$mod SHIFT, 2, movetoworkspace, 2"
        "$mod SHIFT, 3, movetoworkspace, 3"
        "$mod SHIFT, 4, movetoworkspace, 4"
        "$mod SHIFT, 5, movetoworkspace, 5"
        "$mod SHIFT, 6, movetoworkspace, 6"
        "$mod SHIFT, 7, movetoworkspace, 7"
        "$mod SHIFT, 8, movetoworkspace, 8"
        "$mod SHIFT, 9, movetoworkspace, 9"
        "$mod SHIFT, 0, movetoworkspace, 10"
        "$mod, TAB, workspace, m+1"
        "$mod SHIFT, TAB, workspace, m-1"
        ", XF86MonBrightnessUp, exec, brightnessctl -q s +10%"
        ", XF86MonBrightnessDown, exec, brightnessctl -q s 10%-"
        ", XF86AudioRaiseVolume, exec, pactl set-sink-mute @DEFAULT_SINK@ 0 && pactl set-sink-volume @DEFAULT_SINK@ +5%"
        ", XF86AudioLowerVolume, exec, pactl set-sink-mute @DEFAULT_SINK@ 0 && pactl set-sink-volume @DEFAULT_SINK@ -5%"
        ", XF86AudioMute, exec, pactl set-sink-mute @DEFAULT_SINK@ toggle"
        ", XF86AudioPlay, exec, playerctl play-pause"
        ", XF86AudioPause, exec, playerctl pause"
        ", XF86AudioNext, exec, playerctl next"
        ", XF86AudioPrev, exec, playerctl previous"
        ", XF86AudioMicMute, exec, pactl set-source-mute @DEFAULT_SOURCE@ toggle"
        ", XF86Lock, exec, hyprlock"
        ", PRINT, exec, hyprshot -m output"
        "$mod, PRINT, exec, hyprshot -m window"
        "$mod SHIFT, PRINT, exec, hyprshot -m region"
      ];

      # Mouse bindings
      bindm = [
        "$mod, mouse:272, movewindow"
        "$mod, mouse:273, resizewindow"
      ];

      # Special key bindings
      binde = [
        "ALT, Tab, cyclenext"
        "ALT, Tab, bringactivetotop"
      ];
    };
  };

  # Hypridle configuration
  services.hypridle = {
    enable = true;
    settings = {
      general = {
        lock_cmd = "pidof hyprlock || hyprlock";
        before_sleep_cmd = "loginctl lock-session";
        after_sleep_cmd = "hyprctl dispatch dpms on";
      };

      listener = [
        {
          timeout = 600;
          on-timeout = "loginctl lock-session";
        }
        {
          timeout = 660;
          on-timeout = "hyprctl dispatch dpms off";
          on-resume = "hyprctl dispatch dpms on";
        }
        {
          timeout = 1800;
          on-timeout = "systemctl suspend";
        }
      ];
    };
  };

  # Hyprlock configuration
  programs.hyprlock = {
    enable = true;
    settings = {
      background = [
        {
          monitor = "";
          path = "$HOME/Downloads/lock_bg.png";
        }
      ];

      input-field = [
        {
          monitor = "";
          size = "200, 50";
          outline_thickness = 3;
          dots_size = 0.33;
          dots_spacing = 0.15;
          dots_center = true;
          dots_rounding = -1;
          outer_color = "rgb(151515)";
          inner_color = "rgb(FFFFFF)";
          font_color = "rgb(10, 10, 10)";
          fade_on_empty = true;
          fade_timeout = 1000;
          placeholder_text = "<i>Input Password...</i>";
          hide_input = false;
          rounding = -1;
          check_color = "rgb(204, 136, 34)";
          fail_color = "rgb(204, 34, 34)";
          fail_text = "<i>$FAIL <b>($ATTEMPTS)</b></i>";
          fail_transition = 300;
          capslock_color = -1;
          numlock_color = -1;
          bothlock_color = -1;
          invert_numlock = false;
          swap_font_color = false;
          position = "0, -20";
          halign = "center";
          valign = "center";
        }
      ];

      label = [
        {
          monitor = "";
          text = "cmd[update:1000] echo \"$TIME\"";
          color = "rgba(200, 200, 200, 1.0)";
          font_size = 55;
          font_family = "Fira Semibold";
          position = "-100, 70";
          halign = "right";
          valign = "bottom";
          shadow_passes = 5;
          shadow_size = 10;
        }
        {
          monitor = "";
          text = "$USER";
          color = "rgba(200, 200, 200, 1.0)";
          font_size = 20;
          font_family = "Fira Semibold";
          position = "-100, 160";
          halign = "right";
          valign = "bottom";
          shadow_passes = 5;
          shadow_size = 10;
        }
      ];

      image = [
        {
          monitor = "";
          path = "$HOME/.config/ml4w/cache/square_wallpaper.png";
          size = 280;
          rounding = -1;
          border_size = 4;
          border_color = "rgb(221, 221, 221)";
          rotate = 0;
          reload_time = -1;
          position = "0, 200";
          halign = "center";
          valign = "center";
        }
      ];
    };
  };

  # Hyprpaper configuration
  services.hyprpaper = {
    enable = true;
    settings = {
      ipc = "on";
      splash = true;

      preload = [
        "/home/mohi/Pictures/wallpaper.jpg"
      ];

      wallpaper = [
        ",/home/mohi/Pictures/wallpaper.jpg,fill"
      ];
    };
  };
}
