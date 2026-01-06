{ ... }:
{
  wayland.windowManager.hyprland.settings = {
    bind = [
      # Apps
      "SUPER      , RETURN, exec, ghostty"
      "SUPER      , B     , exec, brave"
      "SUPER      , E     , exec, nautilus"
      "SUPER      , P     , exec, wofi --show drun"
      "SUPER CTRL , R     , exec, hyprctl reload"
      "SUPER CTRL , Q     , exec, wlogout -b 6 --protocol layer-shell"
      "SUPER      , V     , exec, cliphist list | wofi --dmenu | cliphist decode | wl-copy"
      "SUPER CTRL , L     , exec, hyprlock"
      "           , PRINT , exec, hyprshot -m output"
      "SUPER      , PRINT , exec, hyprshot -m window"
      "SUPER SHIFT, PRINT , exec, hyprshot -m region"

      # Window Management
      "SUPER      , Q     , killactive"
      "SUPER SHIFT, Q     , exec, hyprctl activewindow | grep pid | tr -d 'pid:' | xargs kill"
      "SUPER      , F     , fullscreen, 0"
      "SUPER      , T     , togglefloating"
      "SUPER      , S     , togglesplit"
      "SUPER SHIFT, D     , swapsplit"
      "SUPER      , left  , movefocus, l"
      "SUPER      , right , movefocus, r"
      "SUPER      , up    , movefocus, u"
      "SUPER      , down  , movefocus, d"
      "SUPER      , H     , movefocus, l"
      "SUPER      , J     , movefocus, d"
      "SUPER      , K     , movefocus, u"
      "SUPER      , L     , movefocus, r"
      "SUPER SHIFT, left  , resizeactive, -100 0"
      "SUPER SHIFT, down  , resizeactive, 0 100"
      "SUPER SHIFT, up    , resizeactive, 0 -100"
      "SUPER SHIFT, right , resizeactive, 100 0"
      "SUPER SHIFT, H     , resizeactive, -100 0"
      "SUPER SHIFT, J     , resizeactive, 0 100"
      "SUPER SHIFT, K     , resizeactive, 0 -100"
      "SUPER SHIFT, L     , resizeactive, 100 0"
      "SUPER ALT  , left  , swapwindow, l"
      "SUPER ALT  , down  , swapwindow, d"
      "SUPER ALT  , up    , swapwindow, u"
      "SUPER ALT  , right , swapwindow, r"
      "SUPER ALT  , H     , swapwindow, l"
      "SUPER ALT  , J     , swapwindow, d"
      "SUPER ALT  , K     , swapwindow, u"
      "SUPER ALT  , L     , swapwindow, r"

      # Workspace
      "SUPER      , 1  , workspace, 1"
      "SUPER      , 2  , workspace, 2"
      "SUPER      , 3  , workspace, 3"
      "SUPER      , 4  , workspace, 4"
      "SUPER      , 5  , workspace, 5"
      "SUPER      , 6  , workspace, 6"
      "SUPER      , 7  , workspace, 7"
      "SUPER      , 8  , workspace, 8"
      "SUPER      , 9  , workspace, 9"
      "SUPER      , 0  , workspace, 10"
      "SUPER SHIFT, 1  , movetoworkspace, 1"
      "SUPER SHIFT, 2  , movetoworkspace, 2"
      "SUPER SHIFT, 3  , movetoworkspace, 3"
      "SUPER SHIFT, 4  , movetoworkspace, 4"
      "SUPER SHIFT, 5  , movetoworkspace, 5"
      "SUPER SHIFT, 6  , movetoworkspace, 6"
      "SUPER SHIFT, 7  , movetoworkspace, 7"
      "SUPER SHIFT, 8  , movetoworkspace, 8"
      "SUPER SHIFT, 9  , movetoworkspace, 9"
      "SUPER SHIFT, 0  , movetoworkspace, 10"
      "SUPER      , TAB, workspace, m+1"
      "SUPER SHIFT, TAB, workspace, m-1"

      # Media Keys
      ", XF86MonBrightnessUp  , exec, brightnessctl -q s +10%"
      ", XF86MonBrightnessDown, exec, brightnessctl -q s 10%-"
      ", XF86AudioRaiseVolume , exec, pactl set-sink-mute @DEFAULT_SINK@ 0 && pactl set-sink-volume @DEFAULT_SINK@ +5%"
      ", XF86AudioLowerVolume , exec, pactl set-sink-mute @DEFAULT_SINK@ 0 && pactl set-sink-volume @DEFAULT_SINK@ -5%"
      ", XF86AudioMute        , exec, pactl set-sink-mute @DEFAULT_SINK@ toggle"
      ", XF86AudioMicMute     , exec, pactl set-source-mute @DEFAULT_SOURCE@ toggle"
      ", XF86AudioPlay        , exec, playerctl play-pause"
      ", XF86AudioPause       , exec, playerctl pause"
      ", XF86AudioNext        , exec, playerctl next"
      ", XF86AudioPrev        , exec, playerctl previous"
      ", XF86Lock             , exec, hyprlock"
    ];

    # Mouse bindings
    bindm = [
      "SUPER, mouse:272, movewindow"
      "SUPER, mouse:273, resizewindow"
    ];

    # Special key bindings
    binde = [
      "ALT, Tab, cyclenext"
      "ALT, Tab, bringactivetotop"
    ];
  };
}
