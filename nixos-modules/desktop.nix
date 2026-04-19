{
  pkgs,
  ...
}:
{
  services = {
    displayManager = {
      defaultSession = "hyprland-uwsm";
      sddm = {
        enable = true;
        wayland.enable = true;
        theme = "noctalia";
      };
    };

    desktopManager.plasma6.enable = true;
  };

  security.pam.services.sddm.kwallet.enable = true;

  hardware = {
    graphics = {
      enable = true;
      enable32Bit = true;
    };
  };

  xdg.mime.enable = true;
  xdg.menus.enable = true;

  environment.systemPackages =
    (with pkgs; [
      bind
      brave
      cider-2
      compsize
      curl
      discord
      easyeffects
      gparted
      jq
      kdiskmark
      killall
      lshw
      mousam
      p7zip
      shared-mime-info
      streamcontroller
      teamspeak6-client
      telegram-desktop
      transmission_4-gtk
      wayland-utils
      websocat
      wiremix
      wl-clipboard
    ])
    ++ (with pkgs.kdePackages; [
      breeze-icons
      dolphin
      kdegraphics-thumbnailers
      kdf
      kio
      kio-admin
      kio-extras
      kio-fuse
      kservice
      plasma-integration
      qtsvg
      qtwayland
    ]);
}
