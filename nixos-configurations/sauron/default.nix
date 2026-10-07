{
  inputs,
  overlays,
  pkgs,
  ...
}:
let
  sauronOverlays = [
    (final: prev: { btop = prev.btop.override { cudaSupport = true; }; })
  ];

  monitors = {
    main = {
      output = "desc:ASUSTek COMPUTER INC PG32UCDM S6LMQS030023";
      mode = "3840x2160@240";
      position = "3072x0";
      scale = 1.25;
      bitdepth = 10;
      vrr = 0;
      cm = "srgb";
    };

    side = {
      output = "desc:ASUSTek COMPUTER INC XG32UCDS W3LMQV042954";
      mode = "3840x2160@165";
      position = "0x0";
      scale = 1.25;
      bitdepth = 10;
      vrr = 0;
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

  # Keep this outside hardware.nix so nixos-generate-config cannot remove it.
  # Existing data stays uncompressed until rewritten.
  fileSystems = {
    "/".options = [ "compress=zstd:3" ];
    "/home".options = [ "compress=zstd:3" ];
    "/nix".options = [ "compress=zstd:3" ];
  };

  networking = {
    hostName = "sauron";
    # Disabled intentionally — machine is behind a NAT router with no port forwarding,
    # and dev work requires frequent port exposure for testing.
    firewall.enable = false;
  };

  nixpkgs.overlays = overlays ++ sauronOverlays;

  # / and /nix share one filesystem, so the default device deduplication scrubs it once.
  services = {
    btrfs.autoScrub.enable = true;
    openssh.enable = true;
    flatpak = {
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
  };

  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;

    extraSpecialArgs = {
      inherit inputs;
    };

    users.mohi = {
      imports = [
        inputs.dms.homeModules.dank-material-shell
        ../../home-configurations/mohi

        ../../home-modules
        ../../home-modules/nixos
      ];

      dotfiles.host = {
        isNvidia = true;
        monitors = builtins.attrValues monitors;
        workspaces = [
          {
            id = 1;
            monitor = monitors.side.output;
            default = true;
            persistent = true;
          }
          {
            id = 3;
            monitor = monitors.side.output;
            persistent = true;
          }
          {
            id = 5;
            monitor = monitors.side.output;
            persistent = true;
          }
          {
            id = 7;
            monitor = monitors.side.output;
            persistent = true;
          }
          {
            id = 9;
            monitor = monitors.side.output;
            persistent = true;
          }
          {
            id = 2;
            monitor = monitors.main.output;
            default = true;
            persistent = true;
          }
          {
            id = 4;
            monitor = monitors.main.output;
            persistent = true;
          }
          {
            id = 6;
            monitor = monitors.main.output;
            persistent = true;
          }
          {
            id = 8;
            monitor = monitors.main.output;
            persistent = true;
          }
          {
            id = 10;
            monitor = monitors.main.output;
            persistent = true;
          }
        ];
      };

      home.packages = [ pkgs.docker-compose ];
    };
  };
}
