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
      withApplet = false;
    };

    # KWallet is the selected secret backend; avoid GNOME Keyring racing for
    # org.freedesktop.secrets and confusing Chromium/Brave session encryption.
    gnome.gnome-keyring.enable = lib.mkForce false;
  };

  systemd.user.services.blueman-applet = {
    description = "Blueman tray applet";
    wantedBy = [ "graphical-session.target" ];
    partOf = [ "graphical-session.target" ];

    serviceConfig = {
      Type = "dbus";
      BusName = "org.blueman.Applet";
      ExecCondition = "${pkgs.runtimeShell} -c 'case \":$XDG_CURRENT_DESKTOP:\" in *:Hyprland:*|*:hyprland:*|*:Niri:*|*:niri:*) exit 0;; *) exit 1;; esac'";
      ExecStart = "${pkgs.blueman}/bin/blueman-applet";
      Restart = "on-failure";
    };
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
