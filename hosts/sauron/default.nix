_: {
  hostConfig = {
    monitors = [
      {
        output = "desc:ASUSTek COMPUTER INC PG32UCDM S6LMQS030023";
        mode = "3840x2160@240";
        position = "0x0";
        scale = 1;
        bitdepth = 10;
        vrr = false;
      }
      {
        output = "desc:LG Electronics LG ULTRAGEAR 305MXDM47154";
        mode = "2560x1440@180";
        position = "-2560x-160";
        scale = 1;
        bitdepth = 10;
        vrr = false;
      }
    ];
    workspaces = [
      "1, monitor:desc:LG Electronics LG ULTRAGEAR 305MXDM47154, default:true, persistent:true"
      "2, monitor:desc:ASUSTek COMPUTER INC PG32UCDM S6LMQS030023, default:true, persistent:true"
      "3, monitor:desc:LG Electronics LG ULTRAGEAR 305MXDM47154"
      "4, monitor:desc:ASUSTek COMPUTER INC PG32UCDM S6LMQS030023"
      "5, monitor:desc:LG Electronics LG ULTRAGEAR 305MXDM47154"
      "6, monitor:desc:ASUSTek COMPUTER INC PG32UCDM S6LMQS030023"
      "7, monitor:desc:LG Electronics LG ULTRAGEAR 305MXDM47154"
      "8, monitor:desc:ASUSTek COMPUTER INC PG32UCDM S6LMQS030023"
      "9, monitor:desc:LG Electronics LG ULTRAGEAR 305MXDM47154"
      "10, monitor:desc:ASUSTek COMPUTER INC PG32UCDM S6LMQS030023"
    ];
    primaryMonitor = "desc:ASUSTek COMPUTER INC PG32UCDM S6LMQS030023";
    wallpaper = "~/Pictures/Wallpapers/sunset.jpg";
    nvidia = true;
  };

  nixosModule = {
    imports = [
      ./hardware-configuration.nix
    ];

    networking = {
      hostName = "sauron";
      networkmanager.enable = true;
      firewall.enable = false;
    };

    services.resolved.settings.Resolve.DNS = [ "192.168.1.10#dns.home.biook.me" ];

    system.stateVersion = "25.05";
  };

  modulesExtra = [
    ../../modules/hyprland.nix
    ../../modules/lanzaboote.nix
    ../../modules/nvidia.nix
    ../../modules/dev.nix
    ../../modules/steam.nix
  ];

  homeModulesExtra = [
    ../../home/modules/hyprland.nix
    ../../home/modules/noctalia.nix
    ../../home/modules/theme.nix
  ];
}
