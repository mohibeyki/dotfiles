{
  description = "Mohi's nix config flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

    flake-parts.url = "github:hercules-ci/flake-parts";
    ez-configs.url = "github:ehllie/ez-configs";

    agenix = {
      url = "github:ryantm/agenix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-darwin = {
      url = "github:nix-darwin/nix-darwin/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixvim = {
      url = "github:mohibeyki/nixvim";
      inputs.nixpkgs.follows = "nixpkgs";
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
      inputs.nixpkgs.follows = "nixpkgs";
    };

    llm-agents = {
      url = "github:numtide/llm-agents.nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    noctalia-qs = {
      url = "github:noctalia-dev/noctalia-qs";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    noctalia-shell = {
      url = "github:noctalia-dev/noctalia-shell";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.noctalia-qs.follows = "noctalia-qs";
    };
  };

  outputs =
    inputs:
    let
      # Overlay to fix direnv build on Darwin (CGO required for external linking)
      direnvOverlay = final: prev: {
        direnv = prev.direnv.overrideAttrs (oldAttrs: {
          env = (oldAttrs.env or { }) // {
            CGO_ENABLED = "1";
          };
        });
      };
      overlays = [ direnvOverlay ];
    in
    inputs.flake-parts.lib.mkFlake { inherit inputs; } {
      imports = [
        inputs.ez-configs.flakeModule
      ];

      ezConfigs = {
        root = ./.;
        nixos.specialArgs = { inherit inputs overlays; };
        darwin.specialArgs = { inherit inputs overlays; };
        home.extraSpecialArgs = { inherit inputs overlays; };
      };

      systems = [
        "x86_64-linux"
        "aarch64-darwin"
      ];

      perSystem =
        { system, ... }:
        {
          _module.args.pkgs = import inputs.nixpkgs {
            inherit system;
            overlays = [ direnvOverlay ];
          };
        };
    };
}
