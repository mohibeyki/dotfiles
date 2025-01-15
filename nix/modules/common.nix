{
  pkgs,
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
    };
  };

  fonts.packages = with pkgs; [
    nerd-fonts.jetbrains-mono
  ];

  # Enable non-free applications
  nixpkgs.config.allowUnfree = true;

  programs = {
    zsh.enable = true;
    fish.enable = true;
  };

  environment.systemPackages = with pkgs; [
    bc
    btop
    cachix
    clang-tools
    fd
    fishPlugins.tide
    fzf
    gcc
    git
    gnumake
    gnused
    go
    jq
    lazygit
    libiconv
    mc
    nodejs
    python3
    ripgrep
    stow
    tmux
    unzip
    wget
    yarn
    zellij
    zip
    zoxide
  ];
}
