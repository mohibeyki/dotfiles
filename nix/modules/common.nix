{ pkgs, inputs, ... }:
{
  imports = [
    ./fenix.nix
  ];

  nixpkgs.overlays = [
    inputs.neovim-nightly-overlay.overlays.default
  ];

  nix = {
    package = pkgs.nixVersions.latest; # pkgs.nix;

    # Trusted users for cachix
    settings.trusted-users = [
      "root"
      "mohi"
    ];

    # Necessary for using flakes on this system.
    settings.experimental-features = [
      "nix-command"
      "flakes"
    ];
  };

  fonts.packages = [
    (pkgs.nerdfonts.override {
      fonts = [ "JetBrainsMono" ];
    })
  ];

  # Enable non-free applications
  nixpkgs.config.allowUnfree = true;

  # Create /etc/zshrc that loads the nix-darwin environment.
  programs.zsh.enable = true;

  # Enable fish and fix nix packages' order on the PATH
  programs.fish.enable = true;

  environment.systemPackages = with pkgs; [
    alacritty
    bc
    btop
    cachix
    clang-tools
    fd
    gcc
    git
    gnumake
    gnused
    go
    gofumpt
    golangci-lint
    gopls
    jq
    kubectl
    lazygit
    lua-language-server
    markdownlint-cli2
    mc
    neovim
    nil
    nixfmt-rfc-style
    nodejs
    python3
    ripgrep
    selene
    statix
    stylua
    tmux
    tree-sitter
    unzip
    wget
    yarn
    zip
    zoxide
  ];
}
