{
  description = "Mohi's nix config flake";

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

    llm-agents = {
      url = "github:numtide/llm-agents.nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    caelestia-shell = {
      url = "github:caelestia-dots/shell";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    caelestia = {
      url = "github:caelestia-dots/caelestia";
      flake = false;
    };
  };

  outputs =
    { ... }@inputs:
    let
      helpers = import ./helper.nix inputs;
      inherit (helpers) mkMerge mkDarwin mkNixos;
    in
    mkMerge [
      (mkDarwin "legolas" { }
        [
          ./modules/dev.nix
        ]
        [ ]
      )

      (mkNixos "sauron" inputs.nixpkgs
        {
          monitors = [
            {
              output = "desc:ASUSTek COMPUTER INC PG32UCDM S6LMQS030023";
              mode = "3840x2160@240";
              position = "0x0";
              scale = 1.25;
              bitdepth = 10;
              vrr = false;
            }
            {
              output = "desc:LG Electronics LG ULTRAGEAR 305MXDM47154";
              mode = "2560x1440@180";
              position = "-2560x-160";
              scale = 1;
              bitdepth = 10;
              vrr = false;
            }
          ];
          workspaces = [
            "1, monitor:desc:LG Electronics LG ULTRAGEAR 305MXDM47154, default:true, persistent:true"
            "2, monitor:desc:ASUSTek COMPUTER INC PG32UCDM S6LMQS030023, default:true, persistent:true"
            "3, monitor:desc:LG Electronics LG ULTRAGEAR 305MXDM47154"
            "4, monitor:desc:ASUSTek COMPUTER INC PG32UCDM S6LMQS030023"
            "5, monitor:desc:LG Electronics LG ULTRAGEAR 305MXDM47154"
            "6, monitor:desc:ASUSTek COMPUTER INC PG32UCDM S6LMQS030023"
            "7, monitor:desc:LG Electronics LG ULTRAGEAR 305MXDM47154"
            "8, monitor:desc:ASUSTek COMPUTER INC PG32UCDM S6LMQS030023"
            "9, monitor:desc:LG Electronics LG ULTRAGEAR 305MXDM47154"
            "10, monitor:desc:ASUSTek COMPUTER INC PG32UCDM S6LMQS030023"
          ];
          primaryMonitor = "desc:ASUSTek COMPUTER INC PG32UCDM S6LMQS030023";
          wallpaper = "~/Pictures/Wallpapers/sunset.jpg";
          nvidia = true;
        }
        [
          ./modules/hyprland.nix
          ./modules/lanzaboote.nix
          ./modules/nvidia.nix
          ./modules/dev.nix
          ./programs/steam.nix
        ]
        [
          ./home/modules/caelestia.nix
          ./home/modules/theme.nix
        ]
      )
    ];
}
