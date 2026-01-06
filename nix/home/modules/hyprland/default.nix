{ inputs, pkgs, ... }:
{
  imports = [
    ../mako.nix
    ../theme.nix
    ../waybar.nix
    ../wlogout.nix
    ../wofi.nix

    ./binds.nix
    ./hyprpaper.nix
    ./monitors.nix
    ./rules.nix
    ./variables.nix
  ];

  wayland.windowManager.hyprland = {
    enable = true;

    package = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland;
    portalPackage =
      inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.xdg-desktop-portal-hyprland;

    systemd.enable = false;
    xwayland.enable = true;

    settings = {
      # Environment variables
      env = [
        "XDG_CURRENT_DESKTOP,Hyprland"
        "XDG_SESSION_TYPE,wayland"
        "XDG_SESSION_DESKTOP,Hyprland"
        "GBM_BACKEND,nvidia-drm"
        "__GLX_VENDOR_LIBRARY_NAME,nvidia"
        "LIBVA_DRIVER_NAME,nvidia"
        "ELECTRON_OZONE_PLATFORM_HINT,auto"
        "NVD_BACKEND,direct"
      ];

      # General
      general = {
        border_size = 0;
        gaps_in = 8;
        gaps_out = 8;
        layout = "dwindle";
        locale = "en_US";
      };

      # Exec on startup
      exec-once = [
        "waybar"
        "hyprpaper"
        "wl-paste --type text --watch cliphist store"
        "wl-paste --type image --watch cliphist store"
      ];

      # Misc
      misc = {
        disable_hyprland_logo = true;
        disable_splash_rendering = true;
        font_family = "JetBrainsMono Nerd Font";
        vrr = 1;
      };

      # Layout
      dwindle = {
        pseudotile = true;
        preserve_split = true;
      };

      # Workspaces
      workspace = [
        "1, monitor:DP-4"
        "2, monitor:DP-5"
        "3, monitor:DP-4"
        "4, monitor:DP-5"
        "5, monitor:DP-4"
        "6, monitor:DP-5"
        "7, monitor:DP-4"
        "8, monitor:DP-5"
        "9, monitor:DP-4"
        "10, monitor:DP-5"
      ];
    };
  };
}
