{ ... }:
{
  wayland.windowManager.hyprland.settings = {
    decoration = {
      rounding = 4;
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
  };
}
