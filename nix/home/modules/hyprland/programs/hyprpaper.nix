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
        "DP-2, /home/mohi/Pictures/wallpaper.jpg"
        "DP-1, /home/mohi/Pictures/wallpaper.jpg"
      ];
    };
  };
}
