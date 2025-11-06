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
      package = pkgs.orchis-theme;
      name = "Orchis";
    };

    iconTheme = {
      package = pkgs.papirus-icon-theme;
      name = "Papirus";
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
        gaps_in = 8;
        gaps_out = 8;
        layout = "dwindle";
        border_size = 0;
      };

      env = [
        # portal
        "XDG_CURRENT_DESKTOP,Hyprland"
        "XDG_SESSION_TYPE,wayland"
        "XDG_SESSION_DESKTOP,Hyprland"

        # nvidia
        "GBM_BACKEND,nvidia-drm"
        "__GLX_VENDOR_LIBRARY_NAME,nvidia"
        "LIBVA_DRIVER_NAME,nvidia"
        "NVD_BACKEND,direct"

        # electron
        "ELECTRON_OZONE_PLATFORM_HINT,auto"

        # sdl
        "SDL_VIDEODRIVER,wayland"

        # gdk
        "GDK_SCALE,1"
      ];

      monitor = [
        "DP-4, 2560x1440@180, -2560x0, 1, bitdepth, 10"
        "DP-5, 3840x2160@240,     0x0, 1, bitdepth, 10"
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
