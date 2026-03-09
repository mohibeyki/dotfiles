{ hostConfig, ... }:
{
  wayland.windowManager.hyprland.settings = {
    monitorv2 = hostConfig.monitors;
  };
}
