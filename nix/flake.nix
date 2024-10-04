{
  description = "Mohi's NixOS / nix-darwin config flake";

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

    hyprland = {
      url = "github:hyprwm/hyprland";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    neovim-nightly-overlay.url = "github:nix-community/neovim-nightly-overlay";
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
            ./cachix.nix
            ./hosts/legolas/configuration.nix
            ./modules/common.nix
            ./modules/darwin.nix
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
            ./cachix.nix
            ./hosts/sauron/configuration.nix
            ./modules/nvidia.nix
            ./modules/common.nix
            ./modules/nixos.nix
            ./modules/steam.nix

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
