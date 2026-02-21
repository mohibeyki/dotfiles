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
    noto-fonts
    noto-fonts-cjk-sans
    noto-fonts-color-emoji
  ];

  # Enable non-free applications
  nixpkgs.config.allowUnfree = true;

  # llm-agents overlay
  nixpkgs.overlays = [ inputs.llm-agents.overlays.default ];

  programs = {
    zsh.enable = true;
    fish.enable = true;
  };

  environment.systemPackages = with pkgs; [
    btop
    cachix
    gnused
    mc
    stow
    superfile
    tmux
    unzip
    wget
    xz
    zip
  ];
}
