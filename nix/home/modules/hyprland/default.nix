{ inputs, pkgs, ... }:
{
  xdg.portal = {
    enable = true;
    extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
    configPackages = [
      pkgs.xdg-desktop-portal-gtk
      pkgs.xdg-desktop-portal
    ];
  };

  imports = [
    ./programs/hypridle.nix
    ./programs/hyprlock.nix
    ./programs/hyprpaper.nix
    ./programs/mako.nix
    ./programs/waybar.nix
    ./programs/wofi.nix
  ];

  wayland.windowManager.hyprland = {
    enable = true;
    package = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland;

    plugins = [
    ];

    settings = {
      monitor = [
        "DP-5,3840x2160@240,1440x600,1"
        "DP-4,2560x1440@180,0x0,1,transform,3"
      ];

      "$mod" = "SUPER";

      input = {
        kb_layout = "us";
        kb_variant = "";
        kb_options = "altwin:swap_lalt_lwin";
      };

      bind = [
        "$mod+CONTROL, R, submap, resize"
        ", XF86AudioRaiseVolume, exec, pactl -- set-sink-volume 0 +10%"
        ", XF86AudioLowerVolume, exec, pactl -- set-sink-volume 0 -10%"
        ", XF86AudioMute, exec, pactl -- set-sink-mute 0 toggle"
        ", XF86AudioMicMute, exec, pactl -- set-source-mute 0 toggle"
        ", XF86AudioPlay, exec, playerctl play-pause"
        ", XF86AudioPause, exec, playerctl play-pause"
        ", XF86AudioNext, exec, playerctl next"
        ", XF86AudioPrev, exec, playerctl previous"
        "$mod, V, exec, cliphist list | wofi --dmenu | cliphist decode | wl-copy"
        ",XF86MonBrightnessUp, exec, brightnessctl s 10%+"
        ",XF86MonBrightnessDown, exec, brightnessctl s 10%-"
        ", XF86Display, exec, light -O && light -I"
        "$mod, f, fullscreen, 1"
        "$mod+SHIFT, f, fullscreen, 0"
        "$mod+SHIFT, tab, togglefloating"
        "$mod, 1, workspace, 01"
        "$mod, 2, workspace, 02"
        "$mod, 3, workspace, 03"
        "$mod, 4, workspace, 04"
        "$mod, 5, workspace, 05"
        "$mod, 6, workspace, 06"
        "$mod, 7, workspace, 07"
        "$mod, 8, workspace, 08"
        "$mod, 9, workspace, 09"
        "$mod, 0, workspace, 10"
        "$mod, F1, workspace, 11"
        "$mod, F2, workspace, 12"
        "$mod, F3, workspace, 13"
        "$mod, F4, workspace, 14"
        "$mod, F5, workspace, 15"
        "$mod, F6, workspace, 16"
        "$mod, F7, workspace, 17"
        "$mod, F8, workspace, 18"
        "$mod, F9, workspace, 19"
        "$mod, F10, workspace, 20"
        "$mod, HOME, exec, wlogout --protocol layer-shell"
        "$mod, E, exec, nemo"
        "$mod, D, exec, wofi --show drun"
        "$mod, return, exec, ghostty"
        "$mod+SHIFT, return, exec, alacritty --class AlacrittyFloating"
      ];
      bindm = [
        "$mod, mouse:272, movewindow"
        "$mod, mouse:273, resizewindow"
      ];
      exec-once = [
        "hyprctl setcursor Bibata-Modern-Classic 30"
        "wl-paste --type text --watch cliphist store"
        "wl-paste --type image --watch cliphist store"
        "nm-applet"
        "waybar"
      ];
      gestures = {
        workspace_swipe = true;
        workspace_swipe_fingers = 3;
        workspace_swipe_forever = true;
        workspace_swipe_cancel_ratio = 0.15;
      };
      decoration = {
        rounding = 5;
        blur = {
          enabled = true;
          size = 7;
          passes = 4;
          noise = 8.0e-3;
          contrast = 0.8916;
          brightness = 0.8;
        };
      };
      misc = {
        disable_hyprland_logo = true;
        disable_splash_rendering = true;
        vrr = 1;
        key_press_enables_dpms = true;
      };
      binds = {
        workspace_back_and_forth = true;
      };
      plugin = {
        hy3 = {
          tabs = {
            height = 2;
            padding = 6;
            render_text = false;
          };
          autotile = {
            enable = true;
            trigger_width = 800;
            trigger_height = 500;
          };
        };
      };
      layerrule = [
        "blur, wofi"
        "ignorezero, wofi"
        "noanim, ^(selection)$"
      ];
      animations = {
        enabled = true;

        bezier = [
          "windowIn, 0.06, 0.71, 0.25, 1"
          "windowResize, 0.04, 0.67, 0.38, 1"
        ];

        animation = [
          "windowsIn, 1, 3, windowIn, slide"
          "windowsOut, 1, 3, windowIn, slide #popin 70%"
          "windowsMove, 1, 2.5, windowResize"
          "border, 1, 10, default"
          "borderangle, 1, 8, default"
          "fade, 1, 3, default"
          "workspaces, 1, 6, default"
          "layers, 1, 5, windowIn, slide"
        ];
      };
      general = {
        border_size = 0;
      };
    };
    extraConfig = "
      submap = resize
      binde = , right, resizeactive, 10 0
      binde = , left, resizeactive, -10 0
      binde = , up, resizeactive, 0 -10
      binde = , down, resizeactive, 0 10
      bind = , escape, submap, reset
      submap = reset
      ";
  };
}
