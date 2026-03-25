{ inputs, ... }:
{
  flake.nixosModules.shared =
    { pkgs, ... }:
    {
      nix = {
        package = pkgs.nixVersions.latest;
        settings = {
          experimental-features = [
            "nix-command"
            "flakes"
          ];

          trusted-users = [
            "root"
            "mohi"
          ];

          accept-flake-config = false;

          extra-substituters = [
            "https://cache.numtide.com"
            "https://hyprland.cachix.org"
            "https://nix-community.cachix.org"
            "https://nixpkgs.cachix.org"
          ];

          extra-trusted-public-keys = [
            "niks3.numtide.com-1:DTx8wZduET09hRmMtKdQDxNNthLQETkc/yaX7M4qK0g="
            "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
            "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
            "nixpkgs.cachix.org-1:q91R6hxbwFvDqTSDKwDAV4T5PxqXGxswD8vhONFMeOE="
          ];

          download-buffer-size = 1024 * 1024 * 1024; # 1GB
        };

        gc = {
          automatic = true;
          dates = "weekly";
          options = "--delete-older-than 14d";
        };

        optimise.automatic = true;
      };

      fonts.packages = with pkgs; [
        nerd-fonts.jetbrains-mono
        noto-fonts
        noto-fonts-cjk-sans
        noto-fonts-color-emoji
      ];

      nixpkgs = {
        overlays = [
          inputs.neovim-nightly-overlay.overlays.default
          inputs.fenix.overlays.default
          inputs.llm-agents.overlays.default
        ];
        config.allowUnfree = true;
      };

      programs.direnv = {
        enable = true;
        silent = false;
        loadInNixShell = true;
        direnvrcExtra = "";

        nix-direnv.enable = true;
      };

      environment.systemPackages = with pkgs; [
        btop
        cachix
        git
        gnused
        mc
        neovim
        openssl
        tmux
        unzip
        wget
        xz
        zip
        fd
        dua
        duf
        eza
        yazi
        ranger
      ];
    };
}
