{ ... }:
{
  wayland.windowManager.hyprland.settings = {
    # Input
    input = {
      # Keyboard
      kb_layout = "us";
      kb_options = "altwin:swap_lalt_lwin";
      numlock_by_default = true;
      follow_mouse = 1;
      mouse_refocus = false;

      # Mouse
      sensitivity = -0.2;
      accel_profile = "flat";

      # Touchpad
      touchpad = {
        natural_scroll = true;
        scroll_factor = 1.0;
      };
    };

    # Decoration
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

    # Animations
    animations = {
      enabled = true;

      animation = [
        "global    , 1, 4, default"
        "windows   , 1, 4, default, popin 60%"
        "workspaces, 1, 4, default, slide"
      ];
    };
  };
}
