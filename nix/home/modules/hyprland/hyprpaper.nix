{ hostConfig, ... }:
{
  services.hyprpaper = {
    enable = true;

    settings = {
      ipc = "on";
      splash = false;
      preload = [ hostConfig.wallpaper ];
      wallpaper = {
        monitor = "";
        path = hostConfig.wallpaper;
        fit_mode = "fill";
      };
    };
  };
}
