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

  # https://github.com/NixOS/nixpkgs/issues/409986
  environment.etc."xdg/menus/applications.menu".source =
    "${pkgs.kdePackages.plasma-workspace}/etc/xdg/menus/plasma-applications.menu";

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
      ark
      baloo
      baloo-widgets
      breeze-icons
      dolphin
      dolphin-plugins
      gwenview
      kate
      kdegraphics-thumbnailers
      kdf
      kio
      kio-admin
      kio-extras
      kio-fuse
      kservice
      okular
      plasma-integration
      qtsvg
      qtwayland
    ]);
}
