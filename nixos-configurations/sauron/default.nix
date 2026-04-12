{ inputs, ... }:
let
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
      vrr = true;
      cm = "srgb";
    };

    side = {
      output = "desc:LG Electronics LG ULTRAGEAR 305MXDM47154";
      mode = "2560x1440@144";
      position = "-2560x-80";
      scale = 1;
      bitdepth = 10;
      vrr = true;
      cm = "srgb";
    };
  };
in
{
  imports = [
    inputs.home-manager.nixosModules.home-manager
    inputs.nix-flatpak.nixosModules.nix-flatpak

    ./hardware.nix

    ../../modules/dev.nix
    ../../modules/shared.nix
    ../../nixos-modules/containers.nix
    ../../nixos-modules/default.nix
    ../../nixos-modules/desktop.nix
    ../../nixos-modules/sddm.nix
    ../../nixos-modules/hyprland.nix
    ../../nixos-modules/nvidia.nix
    ../../nixos-modules/game.nix
  ];

  networking.hostName = "sauron";

  noctalia.sddm.background = ../../assets/sddm.jpg;

  nixpkgs.overlays = sauronOverlays;

  services.flatpak = {
    remotes = [
      {
        name = "flathub";
        location = "https://flathub.org/repo/flathub.flatpakrepo";
      }
    ];

    packages = [
      "com.bambulab.BambuStudio"
      "com.heroicgameslauncher.hgl"
      "io.github.flattool.Warehouse"
      "net.davidotek.pupgui2"
      "net.lutris.Lutris"
      "page.kramo.Cartridges"
    ];
  };

  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;

    extraSpecialArgs = {
      inherit inputs;
      hostConfig = {
        isNvidia = true;
        gitSigningKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINXLVyVxRPmymadz+LcJr9aia6IRnvkA1QfkFzdGELjn mohi@sauron";
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
        primaryMonitor = monitors.main.output;
      };
    };

    users.mohi = {
      imports = [
        inputs.noctalia-shell.homeModules.default
        ../../home-configurations/mohi

        ../../home-modules/common.nix
        ../../home-modules/docker.nix
        ../../home-modules/fish.nix
        ../../home-modules/ghostty.nix
        ../../home-modules/git.nix
        ../../home-modules/helix.nix
        ../../home-modules/hyprland.nix
        ../../home-modules/hyprland-rules.nix
        ../../home-modules/noctalia.nix
        ../../home-modules/theme.nix
        ../../home-modules/tmux.nix
        ../../home-modules/zed.nix
        ../../home-modules/zellij.nix
      ];
    };
  };
}
