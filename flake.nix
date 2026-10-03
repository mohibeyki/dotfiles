{
  description = "Mohi's nix config flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nix-flatpak.url = "github:gmodena/nix-flatpak";

    flake-parts = {
      url = "github:hercules-ci/flake-parts";
      inputs.nixpkgs-lib.follows = "nixpkgs";
    };

    nix-darwin = {
      url = "github:nix-darwin/nix-darwin/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    hyprland = {
      url = "github:hyprwm/Hyprland";
    };

    rose-pine-hyprcursor = {
      url = "github:ndom91/rose-pine-hyprcursor";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    llm-agents = {
      url = "github:numtide/llm-agents.nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    dms = {
      url = "github:AvengeMedia/DankMaterialShell/stable";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    neovim-nightly-overlay = {
      url = "github:nix-community/neovim-nightly-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    inputs:
    let
      overlays = [
        inputs.neovim-nightly-overlay.overlays.default
      ];
    in
    inputs.flake-parts.lib.mkFlake { inherit inputs; } (
      { config, lib, ... }:
      {
        flake = {
          nixosConfigurations.sauron = inputs.nixpkgs.lib.nixosSystem {
            system = "x86_64-linux";
            specialArgs = { inherit inputs overlays; };
            modules = [ ./nixos-configurations/sauron/default.nix ];
          };

          darwinConfigurations.legolas = inputs.nix-darwin.lib.darwinSystem {
            specialArgs = { inherit inputs overlays; };
            modules = [ ./darwin-configurations/legolas/default.nix ];
          };
        };

        systems = [
          "x86_64-linux"
          "aarch64-darwin"
        ];

        perSystem =
          { pkgs, system, ... }:
          {
            devShells.default = pkgs.mkShell {
              packages = with pkgs; [
                nixd
                nixfmt
                statix
                treefmt
                python3
              ];
            };

            # Eval-only: does not build the host. Realizes a drvPath string so
            # `nix flake check` on this system actually type-checks the matching
            # host (legolas on Darwin, sauron on Linux).
            checks =
              lib.optionalAttrs (system == "aarch64-darwin") {
                host-eval = pkgs.runCommand "legolas-eval" { } ''
                  echo ${builtins.unsafeDiscardStringContext config.flake.darwinConfigurations.legolas.system.drvPath} > $out
                '';
              }
              // lib.optionalAttrs (system == "x86_64-linux") {
                host-eval = pkgs.runCommand "sauron-eval" { } ''
                  echo ${builtins.unsafeDiscardStringContext config.flake.nixosConfigurations.sauron.config.system.build.toplevel.drvPath} > $out
                '';
              };
          };
      }
    );
}
