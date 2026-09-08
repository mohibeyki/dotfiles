{
  lib,
  pkgs,
  ...
}:
{
  programs = {
    firefox.enable = true;
    kde-pim.enable = false;
    _1password.enable = true;
    _1password-gui = {
      enable = true;
      polkitPolicyOwners = [ "mohi" ];
    };
  };

  services = {
    desktopManager.plasma6.enable = true;
    # Plasma 6 enables these as mkDefault; Hyprland is the primary session.
    orca.enable = false;
    blueman = {
      enable = true;
    };

    # KWallet is the selected secret backend; avoid GNOME Keyring racing for
    # org.freedesktop.secrets and confusing Chromium-based session encryption.
    gnome.gnome-keyring.enable = lib.mkForce false;
  };

  security.pam.services = {
    login.enableGnomeKeyring = lib.mkForce false;
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
      "text/html" = "brave-origin.desktop";
      "application/xhtml+xml" = "brave-origin.desktop";
      "x-scheme-handler/http" = "brave-origin.desktop";
      "x-scheme-handler/https" = "brave-origin.desktop";
      "x-scheme-handler/about" = "brave-origin.desktop";
      "x-scheme-handler/unknown" = "brave-origin.desktop";
    };
  };
  xdg.menus.enable = true;

  environment = {
    sessionVariables.BROWSER = "brave-origin";

    # Allow the 1Password desktop app to unlock the Brave Origin extension.
    # https://wiki.nixos.org/wiki/1Password#Unlocking_browser_extensions
    etc."1password/custom_allowed_browsers" = {
      text = ''
        brave
        brave-origin
      '';
      mode = "0755";
    };

    # https://github.com/NixOS/nixpkgs/issues/409986
    etc."xdg/menus/applications.menu".source =
      "${pkgs.kdePackages.plasma-workspace}/etc/xdg/menus/plasma-applications.menu";

    systemPackages =
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
        brave-origin
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
  };
}
