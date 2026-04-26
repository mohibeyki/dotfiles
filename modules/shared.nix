{
  overlays,
  pkgs,
  ...
}:
{
  nix = {
    package = pkgs.nixVersions.latest;
    settings = {
      accept-flake-config = false;
      download-buffer-size = 256 * 1024 * 1024; # 256MiB

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
        "https://nix-community.cachix.org"
        "https://nixpkgs.cachix.org"
      ];

      extra-trusted-public-keys = [
        "niks3.numtide.com-1:DTx8wZduET09hRmMtKdQDxNNthLQETkc/yaX7M4qK0g="
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
        "nixpkgs.cachix.org-1:q91R6hxbwFvDqTSDKwDAV4T5PxqXGxswD8vhONFMeOE="
      ];

      auto-optimise-store = true;
    };

    gc = {
      automatic = true;
      options = "--delete-older-than 14d";
    };
  };

  fonts.packages = with pkgs; [
    nerd-fonts.jetbrains-mono
    noto-fonts
    noto-fonts-cjk-sans
    noto-fonts-color-emoji
  ];

  nixpkgs = {
    inherit overlays;
    config.allowUnfree = true;
  };

  environment.systemPackages = with pkgs; [
    btop
    dua
    duf
    eza
    fd
    gnused
    mc
    openssl
    ripgrep
    unzip
    wget
    xz
    yazi
    zip
  ];
}
