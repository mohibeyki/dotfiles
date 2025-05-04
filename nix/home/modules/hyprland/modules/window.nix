{ ... }:
{
  wayland.windowManager.hyprland.settings = {

    windowrule = [
      "tile, title:^(Brave-browser)$"
      "float, title:^(pavucontrol)$"
      "float, title:^(blueman-manager)$"
      "float, title:^(nm-connection-editor)$"
      "float, title:^(Calculator)$"

      "float, title:^(Picture-in-Picture)$"
      "pin, title:^(Picture-in-Picture)$"
      "move 69.5% 4%, title:^(Picture-in-Picture)$"

      "idleinhibit fullscreen,class:([window])"
    ];
  };
}
