{
  description = "Mohi's NixOS / nix-darwin config flake";

  inputs = {
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

    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };

  outputs = { self, fenix, nixpkgs, nix-darwin, lanzaboote, ... } @ inputs:
    {
      packages.x86_64-linux.default = fenix.packages.x86_64-linux.default;
      nixosConfigurations = {
        sauron = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          specialArgs = {
            inherit inputs;
          };
          modules = [
            ./cachix.nix
            lanzaboote.nixosModules.lanzaboote
            ./hosts/sauron/configuration.nix
            ./modules/common/common.nix
            ./modules/nixos/nixos.nix

            ({ pkgs, lib, ... }: {
              boot.loader.systemd-boot.enable = lib.mkForce false;

              boot.lanzaboote = {
                enable = true;
                pkiBundle = "/etc/secureboot";
              };
            })
          ];
        };
      };
    };
}
