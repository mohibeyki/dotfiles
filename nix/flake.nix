{
  description = "Mohi's nix config flake";

  nixConfig = {
    substituters = [
      "https://cache.nixos.org"
      "https://nixpkgs.cachix.org"
      "https://nix-community.cachix.org"
    ];

    extra-trusted-public-keys = [
      "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
      "nixpkgs.cachix.org-1:q91R6hxbwFvDqTSDKwDAV4T5PxqXGxswD8vhONFMeOE="
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
    ];
  };

  inputs = {
    nixpkgs.url = "nixpkgs/nixpkgs-unstable";

    nix-darwin = {
      url = "github:nix-darwin/nix-darwin/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    fenix = {
      url = "github:nix-community/fenix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    neovim-nightly-overlay = {
      url = "github:nix-community/neovim-nightly-overlay";
    };

    lanzaboote = {
      url = "github:nix-community/lanzaboote/v0.4.2";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    hyprland = {
      url = "github:hyprwm/Hyprland";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    ghostty = {
      url = "github:ghostty-org/ghostty";
    };
  };

  outputs =
    { ... }@inputs:
    let
      helpers = import ./helper.nix inputs;
      inherit (helpers) mkMerge mkDarwin mkNixos;
    in
    mkMerge [
      (mkDarwin "legolas" inputs.nixpkgs
        [
          ./modules/dev.nix
        ]
        [ ]
      )

      (mkDarwin "arwen" inputs.nixpkgs
        [
          ./modules/dev.nix
        ]
        [ ]
      )

      (mkNixos "sauron" inputs.nixpkgs
        [
          # ./modules/hyprand.nix
          ./modules/lanzaboote.nix
          ./modules/nvidia.nix
          ./modules/dev.nix
          ./programs/steam.nix
        ]
        [
          # ./home/modules/hyprland
        ]
      )
    ];
}
