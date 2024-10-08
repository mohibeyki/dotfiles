{
  description = "Mohi's NixOS / nix-darwin config flake";

  nixConfig = {
    extra-substituters = [
      "https://nix-community.cachix.org"
      "https://cache.nixos.org"
      "https://devenv.cachix.org"
      "https://cache.garnix.io"
    ];

    extra-trusted-public-keys = [
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      "nas.paulg.fr:QwhwNrClkzxCvdA0z3idUyl76Lmho6JTJLWplKtC2ig="
      "devenv.cachix.org-1:w1cLUi8dv3hnoSPGAuibQv+f9TZLr6cv/Hm9XgU50cw="
      "cache.garnix.io:CTFPyKSLcx5RMJKfLo5EEPUObbA78b0YQ2DTCJXqr9g="
    ];
  };

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

    nix-darwin = {
      url = "github:LnL7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager";
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
      home-manager,
      lanzaboote,
      ...
    }:
    let
      inherit (self) outputs;
      pkgsFor = nixpkgs.legacyPackages;
    in
    {
      overlays = import ./overlays { inherit inputs; };

      nixosModules = import ./modules/nixos;
      darwinModules = import ./modules/darwin;
      homeManagerModules = import ./modules/home-manager;

      darwinConfigurations = {
        legolas = nix-darwin.lib.darwinSystem {
          specialArgs = {
            inherit self inputs;
          };

          system = "aarch64-darwin";
          modules = [
            ./hosts/legolas/configuration.nix
            ./modules/common.nix
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
            ./hosts/sauron/configuration.nix
            ./modules/nvidia.nix
            ./modules/common.nix
            ./modules/hyprland.nix
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

      homeConfigurations = {
        "mohi@legolas" = home-manager.lib.homeManagerConfiguration {
          pkgs = pkgsFor.aarch64-darwin;
          modules = [ ./home/legolas.nix ];
          extraSpecialArgs = {
            inherit inputs outputs;
          };
        };
      };

      homeConfigurations = {
        "mohi@sauron" = home-manager.lib.homeManagerConfiguration {
          pkgs = pkgsFor.x86_64-linux;
          modules = [ ./home/sauron.nix ];
          extraSpecialArgs = {
            inherit inputs outputs;
          };
        };
      };
    };
}
