{
  inputs,
  overlays,
  pkgs,
  ...
}:
let
  keys = import ../../modules/keys.nix;

  sauronOverlays = [
    (final: prev: { btop = prev.btop.override { cudaSupport = true; }; })
  ];

  monitors = {
    main = {
      output = "desc:ASUSTek COMPUTER INC PG32UCDM S6LMQS030023";
      mode = "3840x2160@240";
      position = "0x0";
      scale = 1;
      bitdepth = 10;
      vrr = 1;
      cm = "srgb";
    };

    side = {
      output = "desc:LG Electronics LG ULTRAGEAR 305MXDM47154";
      mode = "2560x1440@144";
      position = "-2560x-80";
      scale = 1;
      bitdepth = 10;
      vrr = 1;
      cm = "srgb";
    };
  };
in
{
  imports = [
    inputs.home-manager.nixosModules.home-manager
    inputs.nix-flatpak.nixosModules.nix-flatpak

    ./hardware.nix

    ../../modules/system-dev.nix
    ../../modules/shared.nix
    ../../nixos-modules
  ];

  time.timeZone = "America/Los_Angeles";

  networking = {
    hostName = "sauron";
    # Disabled intentionally — machine is behind a NAT router with no port forwarding,
    # and dev work requires frequent port exposure for testing.
    firewall.enable = false;
  };
  services.openssh.enable = true;

  nixpkgs.overlays = overlays ++ sauronOverlays;

  services.flatpak = {
    remotes = [
      {
        name = "flathub";
        location = "https://flathub.org/repo/flathub.flatpakrepo";
      }
    ];

    update.auto = {
      enable = true;
      onCalendar = "daily";
    };

    packages = [
      "com.bambulab.BambuStudio"
      "com.discordapp.Discord"
      "com.spotify.Client"
      "io.github.flattool.Warehouse"
      "md.obsidian.Obsidian"
      "page.kramo.Cartridges"
    ];
  };

  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;

    extraSpecialArgs = {
      inherit inputs overlays;
    };

    users.mohi = {
      imports = [
        inputs.noctalia-shell.homeModules.default
        inputs.caelestia-shell.homeManagerModules.default
        inputs.plasma-manager.homeModules.plasma-manager
        ../../home-configurations/mohi

        ../../home-modules
        ../../home-modules/nixos
      ];

      dotfiles.host = {
        isNvidia = true;
        shell = "caelestia";
        gitSigningKey = keys.sauron;
        gitAllowedSigners = builtins.attrValues keys;
        monitors = builtins.attrValues monitors;
        workspaces = [
          "1, monitor:${monitors.side.output}, default:true, persistent:true"
          "10, monitor:${monitors.side.output}, default:true, persistent:true"
          "2, monitor:${monitors.main.output}, persistent:true"
          "3, monitor:${monitors.main.output}, persistent:true"
          "4, monitor:${monitors.main.output}, persistent:true"
          "5, monitor:${monitors.main.output}, persistent:true"
          "6, monitor:${monitors.main.output}, persistent:true"
          "7, monitor:${monitors.main.output}, persistent:true"
          "8, monitor:${monitors.main.output}, persistent:true"
          "9, monitor:${monitors.main.output}, persistent:true"
        ];
      };

      home.packages = [ pkgs.docker-compose ];
    };
  };
}
