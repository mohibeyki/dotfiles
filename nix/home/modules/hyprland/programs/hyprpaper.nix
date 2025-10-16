{ ... }:
{
  services.hyprpaper = {
    enable = true;
    settings = {
      splash = false;
      preload = [
        "/home/mohi/Pictures/wallpaper.png"
        "/home/mohi/Pictures/wallpaper.png"
      ];
      wallpaper = [
        "DP-2, /home/mohi/Pictures/wallpaper.png"
        "DP-1, /home/mohi/Pictures/wallpaper.png"
      ];
    };
  };
}
