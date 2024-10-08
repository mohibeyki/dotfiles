{
  description = "Mohi's NixOS / nix-darwin config flake";

  nixConfig = {
    extra-substituters = [
      "https://nix-community.cachix.org"
    ];

    extra-trusted-public-keys = [
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
    ];
  };

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

    nix-darwin = {
      url = "github:LnL7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    lanzaboote = {
      url = "github:nix-community/lanzaboote/v0.4.1";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    fenix = {
      url = "github:nix-community/fenix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    neovim-nightly-overlay = {
      url = "github:nix-community/neovim-nightly-overlay";
    };
  };

  outputs =
    inputs@{
      self,
      nixpkgs,
      nix-darwin,
      lanzaboote,
      ...
    }:
    {
      darwinConfigurations = {
        legolas = nix-darwin.lib.darwinSystem {
          specialArgs = {
            inherit self inputs;
          };

          system = "aarch64-darwin";
          modules = [
            ./hosts/legolas
            ./modules/darwin.nix
            ./modules/common.nix
            ./overlays
          ];
        };
      };

      nixosConfigurations = {
        sauron = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          specialArgs = {
            inherit self inputs;
          };

          modules = [
            ./hosts/sauron
            ./modules/nixos.nix
            ./modules/nvidia.nix
            ./modules/common.nix
            ./modules/hyprland.nix
            ./modules/steam.nix
            ./overlays

            # Secure boot
            lanzaboote.nixosModules.lanzaboote
            (
              { pkgs, lib, ... }:
              {
                boot.loader.systemd-boot.enable = lib.mkForce false;

                boot.lanzaboote = {
                  enable = true;
                  pkiBundle = "/etc/secureboot";
                };
              }
            )
          ];
        };
      };
    };
}
