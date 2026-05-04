{ ... }:
{
  programs.mangohud = {
    enable = true;

    settings = {
      fps = true;
      frametime = true;
      frame_timing = 1;
      gpu_stats = true;
      gpu_temp = true;
      gpu_mem_temp = true;
      vram = true;
      cpu_stats = true;
      cpu_temp = true;
      ram = true;

      position = "top-left";
      font_size = 20;
      background_alpha = 0.4;
      round_corners = 8;

      toggle_hud = "Shift_R+F12";
    };
  };
}
