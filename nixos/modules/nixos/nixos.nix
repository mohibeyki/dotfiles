{ pkgs, ... }:
{
  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
  };

  environment.sessionVariables = {
    WLR_NO_HARDWARE_CURSOR = "1";
    NIXOS_OZONE_WL = "1";
  };

  xdg.portal = {
    enable = true;
    extraPortals = [ pkgs.xdg-desktop-portal-hyprland ];
  };

  services.keyd = {
    enable = true;
    keyboards = {
      default = {
        ids = [ "*" ];
        settings = {
          main = {
            leftmeta = "oneshot(alt)";
            leftalt = "oneshot(meta)";
          };
        };
      };
    };
  };

  nixpkgs.config.overlays = [
    (self: super: {
      brave = super.brave.override {
        commandLineArgs = "--password-store=gnome --enable-features=UseOzonePlatform --ozone-platform=wayland --disable-gpu-compositing";
      };
    })
  ];

  environment.systemPackages = with pkgs; [
    alacritty
    brave
    discord
    gparted
    hyprpaper
    mako
    niv
    sbctl
    vimix-cursors
    waybar
    wezterm
    wofi
    zed-editor

    (pkgs.waybar.overrideAttrs (oldAttrs: { mesonFlags = oldAttrs.mesonFlags ++ [ "-Dexperimental=true" ]; } ) )
  ];
}
