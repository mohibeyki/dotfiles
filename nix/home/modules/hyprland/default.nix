{ inputs, pkgs, ... }:
{
  xdg.portal = {
    enable = true;
    extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
    configPackages = [
      pkgs.xdg-desktop-portal-gtk
      pkgs.xdg-desktop-portal
    ];
  };

  home = {
    pointerCursor = {
      gtk.enable = true;
      package = pkgs.bibata-cursors;
      name = "Bibata-Modern-Classic";
      size = 16;
    };
  };

  gtk = {
    enable = true;

    theme = {
      package = pkgs.fluent-gtk-theme;
      name = "Fluent";
    };

    iconTheme = {
      package = pkgs.fluent-icon-theme;
      name = "Fluent";
    };

    font = {
      name = "Sans";
      size = 12;
    };
  };

  imports = [
    ./modules
    ./programs/hypridle.nix
    ./programs/hyprlock.nix
    ./programs/hyprpaper.nix
    ./programs/mako.nix
    ./programs/waybar.nix
    ./programs/wlogout.nix
    ./programs/wofi.nix
  ];

  wayland.windowManager.hyprland = {
    enable = true;
    package = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland;

    settings = {

      general = {
        gaps_in = 4;
        gaps_out = 4;
        layout = "dwindle";
        border_size = 0;
      };

      env = [
        "ELECTRON_OZONE_PLATFORM_HINT,auto"
        "LIBVA_DRIVER_NAME,nvidia"
        "NVD_BACKEND,direct"
        "__GLX_VENDOR_LIBRARY_NAME,nvidia"
        "SDL_VIDEODRIVER,wayland"
      ];

      monitor = [
        "DP-5,3840x2160@240,1440x600,1"
        "DP-4,2560x1440@180,0x0,1,transform,3"
      ];

      cursor = {
        no_hardware_cursors = true;
      };

      exec-once = [
        "hyprctl setcursor Bibata-Modern-Classic 16"
        "wl-paste --type text --watch cliphist store"
        "wl-paste --type image --watch cliphist store"
        "nm-applet"
        "waybar"
        "hyprpaper"
      ];

      misc = {
        disable_hyprland_logo = true;
        disable_splash_rendering = true;
        vrr = 1;
        key_press_enables_dpms = true;
      };

      layerrule = [
        "blur, waybar"
        "ignorezero, waybar"
        "blur, wofi"
        "ignorezero, wofi"
        "blur, logout_dialog"
        "ignorezero, logout_dialog"
        "noanim, ^(selection)$"
      ];

    };

    extraConfig = "
      submap = resize
      binde = , right, resizeactive, 10 0
      binde = , left, resizeactive, -10 0
      binde = , up, resizeactive, 0 -10
      binde = , down, resizeactive, 0 10
      bind = , escape, submap, reset
      submap = reset
      ";
  };
}
