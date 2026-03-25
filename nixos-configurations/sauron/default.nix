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
        ../../home-modules/zellij.nix
      ];
    };
  };
}
