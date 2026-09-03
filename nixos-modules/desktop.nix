{
  lib,
  pkgs,
  ...
}:
{
  programs = {
    firefox.enable = true;
    _1password.enable = true;
    _1password-gui = {
      enable = true;
      polkitPolicyOwners = [ "mohi" ];
    };
  };

  services = {
    desktopManager.plasma6.enable = true;
    blueman = {
      enable = true;
    };

    # KWallet is the selected secret backend; avoid GNOME Keyring racing for
    # org.freedesktop.secrets and confusing Chromium-based session encryption.
    gnome.gnome-keyring.enable = lib.mkForce false;
  };

  security.pam.services = {
    login.enableGnomeKeyring = lib.mkForce false;
    sddm.kwallet.enable = true;
  };

  hardware = {
    graphics = {
      enable = true;
      enable32Bit = true;
    };
  };

  xdg.mime = {
    enable = true;
    defaultApplications = {
      "text/html" = "vivaldi-stable.desktop";
      "application/xhtml+xml" = "vivaldi-stable.desktop";
      "x-scheme-handler/http" = "vivaldi-stable.desktop";
      "x-scheme-handler/https" = "vivaldi-stable.desktop";
      "x-scheme-handler/about" = "vivaldi-stable.desktop";
      "x-scheme-handler/unknown" = "vivaldi-stable.desktop";
    };
  };
  xdg.menus.enable = true;

  environment.sessionVariables.BROWSER = "vivaldi";

  # https://github.com/NixOS/nixpkgs/issues/409986
  environment.etc."xdg/menus/applications.menu".source =
    "${pkgs.kdePackages.plasma-workspace}/etc/xdg/menus/plasma-applications.menu";

  environment.systemPackages =
    (with pkgs; [
      bind
      compsize
      curl
      easyeffects
      gparted
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
      vivaldi
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
      filelight
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
      partitionmanager
      plasma-integration
      qtsvg
      qtwayland
    ]);
}
