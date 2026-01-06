{ ... }:
let
  sunset = "~/Pictures/sunset.jpg";
in
{
  services.hyprpaper = {
    enable = true;

    settings = {
      ipc = "on";
      splash = false;
      preload = [ sunset ];
      wallpaper = {
        monitor = "";
        path = sunset;
        fit_mode = "fill";
      };
    };
  };
}
