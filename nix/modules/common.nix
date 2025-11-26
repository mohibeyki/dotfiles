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

      accept-flake-config = true;

      experimental-features = [
        "nix-command"
        "flakes"
      ];

      download-buffer-size = 1024 * 1024 * 1024; # 1GB
    };
  };

  fonts.packages = with pkgs; [
    nerd-fonts.jetbrains-mono
  ];

  # Enable non-free applications
  nixpkgs.config.allowUnfree = true;

  nixpkgs.overlays = [
    inputs.rust-overlay.overlays.default
  ];

  programs = {
    zsh.enable = true;
    fish.enable = true;
  };

  environment.systemPackages = with pkgs; [
    bc # calculator
    btop
    cachix
    fishPlugins.tide
    gnused
    mc
    stow
    tmux
    unzip
    wget
    xz
    zip
    zoxide
  ];
}
