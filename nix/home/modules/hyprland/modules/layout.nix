{ ... }:
{
  wayland.windowManager.hyprland.settings = {

    dwindle = {
      pseudotile = true;
      preserve_split = true;
    };

    binds = {
      workspace_back_and_forth = true;
      allow_workspace_cycles = true;
      pass_mouse_when_bound = false;
    };
  };
}
