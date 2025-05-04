{ ... }:
{
  wayland.windowManager.hyprland.settings = {

    dwindle = {
      pseudotile = true;
      preserve_split = true;
    };

    gestures = {
      workspace_swipe = true;
      workspace_swipe_fingers = 3;
      workspace_swipe_forever = true;
      workspace_swipe_cancel_ratio = 0.15;
    };

    binds = {
      workspace_back_and_forth = true;
      allow_workspace_cycles = true;
      pass_mouse_when_bound = false;
    };
  };
}
