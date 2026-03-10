{
  pkgs,
  inputs,
  ...
}:
{
  nix = {
    package = pkgs.nixVersions.latest; # pkgs.nix;

    settings = {
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

      experimental-features = [
        "nix-command"
        "flakes"
      ];

      download-buffer-size = 1024 * 1024 * 1024; # 1GB
    };
  };

  fonts.packages = with pkgs; [
    nerd-fonts.jetbrains-mono
    noto-fonts
    noto-fonts-cjk-sans
    noto-fonts-color-emoji
  ];

  # Enable non-free applications
  nixpkgs.config.allowUnfree = true;

  # llm-agents overlay
  nixpkgs.overlays = [ inputs.llm-agents.overlays.default ];

  programs = {
    fish.enable = true;
  };

  environment.systemPackages = with pkgs; [
    btop
    cachix
    git
    gnused
    mc
    openssl
    stow
    superfile
    tmux
    unzip
    wget
    xz
    zip
  ];
}
