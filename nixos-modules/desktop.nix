{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.mohi.desktop;
in
{
  options.mohi.desktop.mode = lib.mkOption {
    type = lib.types.enum [
      "gnome"
      "plasma"
    ];
    default = "gnome";
    description = "Desktop stack to pair with the display manager and wallet service.";
  };

  config = {
    services = {
      displayManager = {
        gdm.enable = cfg.mode == "gnome";
        sddm.enable = cfg.mode == "plasma";
      };

      gnome.gnome-keyring.enable = cfg.mode == "gnome";
      gvfs.enable = true;
    };

    hardware = {
      graphics = {
        enable = true;
        enable32Bit = true;
      };
    };

    security = {
      polkit.enable = true;
    };

    environment.systemPackages = with pkgs; [
      bambu-studio
      bind
      blueman
      brave
      compsize
      curl
      discord
      easyeffects
      ghostty
      gparted
      jq
      killall
      lshw
      mousam
      niv
      p7zip
      streamcontroller
      teamspeak6-client
      telegram-desktop
      wayland-utils
      websocat
      wget
      wiremix
      wl-clipboard
      zenity
    ];
  };
}
