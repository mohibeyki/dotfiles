{ inputs, pkgs, hostConfig, ... }:
{
  imports = [
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
        "ELECTRON_OZONE_PLATFORM_HINT,auto"
      ] ++ (if hostConfig.nvidia or false then [
        "GBM_BACKEND,nvidia-drm"
        "__GLX_VENDOR_LIBRARY_NAME,nvidia"
        "LIBVA_DRIVER_NAME,nvidia"
        "NVD_BACKEND,direct"
      ] else []);

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
        vrr = 0;
      };

      # Layout
      dwindle = {
        pseudotile = true;
        preserve_split = true;
      };

      # Workspaces
      workspace = hostConfig.workspaces or [];
    };
  };
}
