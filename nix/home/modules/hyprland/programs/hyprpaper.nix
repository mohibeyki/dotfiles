{ ... }:
{
  services.hyprpaper = {
    enable = true;
    settings = {
      splash = false;
      preload = [
        "/home/mohi/Pictures/wp.png"
        "/home/mohi/Pictures/wp-2.jpg"
      ];
      wallpaper = [
        "DP-5, /home/mohi/Pictures/wp.png"
        "DP-4, /home/mohi/Pictures/wp-2.jpg"
      ];
    };
  };
}
