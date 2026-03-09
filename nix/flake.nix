{
  description = "Mohi's nix config flake";

  nixConfig = {
    substituters = [
      "https://cache.nixos.org"
    ];
    trusted-public-keys = [
      "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
    ];

    extra-substituters = [
      "https://cache.numtide.com"
      "https://hyprland.cachix.org"
      "https://nix-community.cachix.org"
      "https://nixpkgs.cachix.org"
    ];
    extra-trusted-public-keys = [
      "niks3.numtide.com-1:DTx8wZduET09hRmMtKdQDxNNthLQETkc/yaX7M4qK0g="
      "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      "nixpkgs.cachix.org-1:q91R6hxbwFvDqTSDKwDAV4T5PxqXGxswD8vhONFMeOE="
    ];
  };

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

    nix-darwin = {
      url = "github:nix-darwin/nix-darwin/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    neovim-nightly-overlay = {
      url = "github:nix-community/neovim-nightly-overlay";
    };

    fenix = {
      url = "github:nix-community/fenix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    lanzaboote = {
      url = "github:nix-community/lanzaboote";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    hyprland = {
      url = "github:hyprwm/Hyprland";
    };

    llm-agents = {
      url = "github:numtide/llm-agents.nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    caelestia-shell = {
      url = "github:caelestia-dots/shell";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    caelestia = {
      url = "github:caelestia-dots/caelestia";
      flake = false;
    };
  };

  outputs =
    { ... }@inputs:
    let
      helpers = import ./helper.nix inputs;
      inherit (helpers) mkMerge mkDarwin mkNixos;
    in
    mkMerge [
      (mkDarwin "legolas" { }
        [
          ./modules/dev.nix
        ]
        [ ]
      )

      (mkNixos "sauron" inputs.nixpkgs
        {
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
              position = "-2560x0";
              scale = 1;
              bitdepth = 10;
              vrr = false;
            }
          ];
          workspaces = [
            "1, monitor:DP-1"
            "2, monitor:DP-2"
            "3, monitor:DP-1"
            "4, monitor:DP-2"
            "5, monitor:DP-1"
            "6, monitor:DP-2"
            "7, monitor:DP-1"
            "8, monitor:DP-2"
            "9, monitor:DP-1"
            "10, monitor:DP-2"
          ];
          primaryMonitor = "DP-5";
          wallpaper = "~/Pictures/Wallpapers/sunset.jpg";
          nvidia = true;
        }
        [
          ./modules/hyprland.nix
          ./modules/lanzaboote.nix
          ./modules/nvidia.nix
          ./modules/plasma.nix
          ./modules/dev.nix
          ./programs/steam.nix
        ]
        [
          ./home/modules/caelestia.nix
          ./home/modules/mako.nix
          ./home/modules/theme.nix
          ./home/modules/waybar.nix
        ]
      )
    ];
}
