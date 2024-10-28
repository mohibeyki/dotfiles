{
  description = "Mohi's NixOS / nix-darwin config flake";

  nixConfig = {
    substituters = [
      "https://cache.nixos.org"
      "https://nix-community.cachix.org"
      "https://wezterm.cachix.org"
    ];

    extra-trusted-public-keys = [
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
      "wezterm.cachix.org-1:kAbhjYUC9qvblTE+s7S+kl5XM1zVa4skO+E/1IDWdH0="
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

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    neovim-nightly-overlay = {
      url = "github:nix-community/neovim-nightly-overlay";
    };

    nix-homebrew = {
      url = "github:zhaofengli-wip/nix-homebrew";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    homebrew-bundle = {
      url = "github:homebrew/homebrew-bundle";
      flake = false;
    };

    homebrew-core = {
      url = "github:homebrew/homebrew-core";
      flake = false;
    };

    homebrew-cask = {
      url = "github:homebrew/homebrew-cask";
      flake = false;
    };

    aerospace-cask = {
      url = "github:nikitabobko/homebrew-tap";
      flake = false;
    };

    wezterm.url = "github:wez/wezterm?dir=nix";
  };

  outputs =
    inputs@{
      self,
      nixpkgs,
      nix-darwin,
      lanzaboote,
      home-manager,
      nix-homebrew,
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

            nix-homebrew.darwinModules.nix-homebrew
            {
              nix-homebrew = {
                enable = true;
                enableRosetta = false;
                user = "mohi";
                taps = {
                  "homebrew/homebrew-core" = inputs.homebrew-core;
                  "homebrew/homebrew-cask" = inputs.homebrew-cask;
                  "homebrew/homebrew-bundle" = inputs.homebrew-bundle;
                  "nikitabobko/homebrew-tap" = inputs.aerospace-cask;
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
                  inherit self inputs;
                };
              };
            }
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

            # Secure boot
            lanzaboote.nixosModules.lanzaboote
            (
              {
                pkgs,
                lib,
                ...
              }:
              {
                boot.loader.systemd-boot.enable = lib.mkForce false;

                boot.lanzaboote = {
                  enable = true;
                  pkiBundle = "/etc/secureboot";
                };
              }
            )

            home-manager.nixosModules.home-manager
            {
              home-manager = {
                useGlobalPkgs = true;
                useUserPackages = true;
                users.mohi = import ./home/sauron;

                extraSpecialArgs = {
                  inherit self inputs;
                };
              };
            }
          ];
        };
      };
    };
}
