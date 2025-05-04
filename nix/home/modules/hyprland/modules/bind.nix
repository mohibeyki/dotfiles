{ ... }:
{
  wayland.windowManager.hyprland.settings = {
    "$mod" = "SUPER";
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

      "$mod, D, exec, wofi --show drun"
      "$mod CTRL, R, exec, hyprctl reload"
      "$mod, PRINT, exec, hyprshot"
      "$mod CTRL, Q, exec, wlogout"
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
    ];

    bindm = [
      "$mod, mouse:272, movewindow"
      "$mod, mouse:273, resizewindow"
    ];

    binde = [
      "ALT,Tab,cyclenext"
      "ALT,Tab,bringactivetotop"
    ];
  };
}
