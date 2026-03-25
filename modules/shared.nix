{ inputs, pkgs, ... }:
{
  nix = {
    package = pkgs.nixVersions.latest;
    settings = {
      accept-flake-config = false;
      download-buffer-size = 1024 * 1024 * 1024; # 1GB

      experimental-features = [
        "nix-command"
        "flakes"
      ];

      trusted-users = [
        "root"
        "mohi"
      ];

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

      auto-optimise-store = true;
    };

    gc = {
      automatic = true;
      options = "--delete-older-than 14d";

      interval = {
        Weekday = 0;
        Hour = 0;
        Minute = 0;
      };
    };
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
    dua
    duf
    eza
    fd
    git
    gnused
    mc
    openssl
    ranger
    tmux
    unzip
    wget
    xz
    yazi
    zip
  ];
}
