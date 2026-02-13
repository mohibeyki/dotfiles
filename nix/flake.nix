{
  description = "Mohi's nix config flake";

  nixConfig = {
    substituters = [
      "https://cache.nixos.org"
      "https://nixpkgs.cachix.org"
      "https://nix-community.cachix.org"
      "https://hyprland.cachix.org"
    ];

    trusted-substituters = [
      "https://cache.nixos.org"
      "https://nixpkgs.cachix.org"
      "https://nix-community.cachix.org"
      "https://hyprland.cachix.org"
    ];

    extra-trusted-public-keys = [
      "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
      "nixpkgs.cachix.org-1:q91R6hxbwFvDqTSDKwDAV4T5PxqXGxswD8vhONFMeOE="
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
    ];
  };

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nixpkgs-stable.url = "github:NixOS/nixpkgs/nixos-25.11";

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

    ghostty = {
      url = "github:ghostty-org/ghostty";
    };

    nur = {
      url = "github:nix-community/NUR";
      inputs.nixpkgs.follows = "nixpkgs";
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

      (mkNixos "sauron" inputs.nixpkgs-stable
        [
          ./modules/hyprland.nix
          ./modules/lanzaboote.nix
          ./modules/nvidia.nix
          ./modules/dev.nix
          ./programs/steam.nix
        ]
        [
          ./home/modules/hyprland
        ]
      )
    ];
}
