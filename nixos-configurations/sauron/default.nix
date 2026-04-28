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
    (final: prev: { openldap = prev.openldap.overrideAttrs (old: { doCheck = false; }); })
  ];

  monitors = {
    main = {
      output = "desc:ASUSTek COMPUTER INC PG32UCDM S6LMQS030023";
      mode = "3840x2160@240";
      position = "0x0";
      scale = 1;
      bitdepth = 10;
      vrr = 2;
      cm = "srgb";
    };

    side = {
      output = "desc:LG Electronics LG ULTRAGEAR 305MXDM47154";
      mode = "2560x1440@144";
      position = "-2560x-80";
      scale = 1;
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
    ../../nixos-modules/containers.nix
    ../../nixos-modules/default.nix
    ../../nixos-modules/desktop.nix
    ../../nixos-modules/sddm.nix
    ../../nixos-modules/hyprland.nix
    ../../nixos-modules/nvidia.nix
    ../../nixos-modules/game.nix
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
      "io.github.flattool.Warehouse"
      "net.davidotek.pupgui2"
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
        inputs.plasma-manager.homeModules.plasma-manager
        ../../home-configurations/mohi

        ../../home-modules
        ../../home-modules/nixos
      ];

      dotfiles.host = {
        isNvidia = true;
        gitSigningKey = keys.sauron;
        gitAllowedSigners = builtins.attrValues keys;
        monitors = builtins.attrValues monitors;
        workspaces = [
          "1, monitor:${monitors.side.output}, default:true, persistent:true"
          "10, monitor:${monitors.side.output}, persistent:true"
          "2, monitor:${monitors.main.output}, default:true, persistent:true"
          "3, monitor:${monitors.main.output}"
          "4, monitor:${monitors.main.output}"
          "5, monitor:${monitors.main.output}"
          "6, monitor:${monitors.main.output}"
          "7, monitor:${monitors.main.output}"
          "8, monitor:${monitors.main.output}"
          "9, monitor:${monitors.main.output}"
        ];
      };

      home.packages = [ pkgs.docker-compose ];
    };
  };
}
