{ pkgs, inputs, ... }:
{
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

  programs = {
    zsh.enable = true;
    fish.enable = true;

    neovim = {
      enable = true;
      package = inputs.neovim-nightly-overlay.packages.${pkgs.system}.default;
    };
  };

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
    helix
    jq
    kubectl
    lazygit
    lua-language-server
    markdownlint-cli2
    mc
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
