{
  description = "Mohi's nix config flake";

  nixConfig = {
    substituters = [
      "https://cache.nixos.org"
      "https://nix-community.cachix.org"
    ];

    extra-trusted-public-keys = [
      "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
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

    fenix = {
      url = "github:nix-community/fenix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    neovim = {
      url = "github:nix-community/neovim-nightly-overlay";
    };

    nix-homebrew = {
      url = "github:zhaofengli-wip/nix-homebrew";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    homebrew-core = {
      url = "github:homebrew/homebrew-core";
      flake = false;
    };

    homebrew-cask = {
      url = "github:homebrew/homebrew-cask";
      flake = false;
    };
  };

  outputs =
    {
      self,
      fenix,
      neovim,
      nixpkgs,
      nix-darwin,
      nix-homebrew,
      home-manager,
      homebrew-core,
      homebrew-cask,
      ...
    }:
    {
      packages.aarch64-darwin.default = fenix.packages.aarch64-darwin.minimal.toolchain;

      darwinConfigurations = {
        arwen = nix-darwin.lib.darwinSystem {
          specialArgs = {
            inherit
              self
              fenix
              nixpkgs
              ;
          };

          system = "aarch64-darwin";
          modules = [
            ./modules/darwin.nix
            ./modules/common.nix
            ./modules/fenix.nix
            ./hosts/arwen

            nix-homebrew.darwinModules.nix-homebrew
            {
              nix-homebrew = {
                enable = true;
                enableRosetta = false;
                user = "mohi";
                taps = {
                  "homebrew/homebrew-core" = homebrew-core;
                  "homebrew/homebrew-cask" = homebrew-cask;
                };
                mutableTaps = false;
              };
            }

            home-manager.darwinModules.home-manager
            {
              home-manager = {
                useGlobalPkgs = true;
                useUserPackages = true;
                users.mohi = import ./home/arwen;

                extraSpecialArgs = {
                  inherit self neovim;
                };
              };
            }
          ];
        };

        legolas = nix-darwin.lib.darwinSystem {
          specialArgs = {
            inherit
              self
              fenix
              nixpkgs
              ;
          };

          system = "aarch64-darwin";
          modules = [
            ./modules/darwin.nix
            ./modules/common.nix
            ./modules/fenix.nix
            ./hosts/legolas

            nix-homebrew.darwinModules.nix-homebrew
            {
              nix-homebrew = {
                enable = true;
                enableRosetta = false;
                user = "mohi";
                taps = {
                  "homebrew/homebrew-core" = homebrew-core;
                  "homebrew/homebrew-cask" = homebrew-cask;
                };
                mutableTaps = false;
              };
            }

            home-manager.darwinModules.home-manager
            {
              home-manager = {
                useGlobalPkgs = true;
                useUserPackages = true;
                users.mohi = import ./home/legolas;

                extraSpecialArgs = {
                  inherit self neovim;
                };
              };
            }
          ];
        };
      };
    };
}
