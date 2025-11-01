{ ... }:
{
  services.hyprpaper = {
    enable = true;
    settings = {
      splash = false;
      preload = [
        "/home/mohi/Pictures/wallpaper.jpg"
        "/home/mohi/Pictures/wallpaper.jpg"
      ];
      wallpaper = [
        "DP-4, /home/mohi/Pictures/wallpaper.jpg"
        "DP-5, /home/mohi/Pictures/wallpaper.jpg"
      ];
    };
  };
}
