{
  inputs,
  overlays ? [ ],
  ...
}:
let
  mainMonitor = "ASUSTek COMPUTER INC PG32UCDM S6LMQS030023";
  sideMonitor = "LG Electronics LG ULTRAGEAR 305MXDM47154";
in
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
            output = "desc:${mainMonitor}";
            mode = "3840x2160@240";
            position = "0x0";
            scale = 1;
            bitdepth = 10;
            vrr = false;
          }
          {
            output = "desc:${sideMonitor}";
            mode = "2560x1440@180";
            position = "-2560x-80";
            scale = 1;
            bitdepth = 10;
            vrr = false;
          }
        ];
        workspaces = [
          "1, monitor:desc:${sideMonitor}, default:true, persistent:true"
          "2, monitor:desc:${mainMonitor}, default:true, persistent:true"
          "3, monitor:desc:${sideMonitor}"
          "4, monitor:desc:${mainMonitor}"
          "5, monitor:desc:${sideMonitor}"
          "6, monitor:desc:${mainMonitor}"
          "7, monitor:desc:${sideMonitor}"
          "8, monitor:desc:${mainMonitor}"
          "9, monitor:desc:${sideMonitor}"
          "10, monitor:desc:${mainMonitor}"
        ];
        primaryMonitor = "desc:${mainMonitor}";
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
