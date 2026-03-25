{
  inputs,
  overlays ? [ ],
  ...
}:
{
  imports = [
    inputs.home-manager.nixosModules.home-manager

    ./hardware.nix

    ../../modules/dev.nix
    ../../modules/shared.nix
    ../../nixos-modules/containers.nix
    ../../nixos-modules/default.nix
    ../../nixos-modules/desktop.nix
    ../../nixos-modules/gnome.nix
    ../../nixos-modules/hyprland.nix
    ../../nixos-modules/nvidia.nix
    ../../nixos-modules/secureboot.nix
    ../../nixos-modules/steam.nix
  ];

  networking.hostName = "sauron";
  system.stateVersion = "25.05";

  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;

    extraSpecialArgs = {
      inherit inputs overlays;
      hostConfig = {
        monitors = [
          {
            output = "desc:PG32UCDM";
            mode = "3840x2160@240";
            position = "0x0";
            scale = 1;
            bitdepth = 10;
            vrr = false;
          }
          {
            output = "desc:305MXDM47154";
            mode = "2560x1440@180";
            position = "-2560x-160";
            scale = 1;
            bitdepth = 10;
            vrr = false;
          }
        ];
        workspaces = [
          "1, monitor:desc:305MXDM47154, default:true, persistent:true"
          "2, monitor:desc:PG32UCDM, default:true, persistent:true"
          "3, monitor:desc:305MXDM47154"
          "4, monitor:desc:PG32UCDM"
          "5, monitor:desc:305MXDM47154"
          "6, monitor:desc:PG32UCDM"
          "7, monitor:desc:305MXDM47154"
          "8, monitor:desc:PG32UCDM"
          "9, monitor:desc:305MXDM47154"
          "10, monitor:desc:PG32UCDM"
        ];
        primaryMonitor = "desc:PG32UCDM";
        wallpaper = "~/Pictures/Wallpapers/sunset.jpg";
      };
    };

    users.mohi = {
      imports = [
        inputs.noctalia-shell.homeModules.default
        ../../home-configurations/mohi

        ../../home-modules/common.nix
        ../../home-modules/fish.nix
        ../../home-modules/ghostty.nix
        ../../home-modules/git.nix
        ../../home-modules/helix.nix
        ../../home-modules/hyprland.nix
        ../../home-modules/noctalia.nix
        ../../home-modules/theme.nix
        ../../home-modules/tmux.nix
        ../../home-modules/zed.nix
        ../../home-modules/zellij.nix
      ];
    };
  };
}
