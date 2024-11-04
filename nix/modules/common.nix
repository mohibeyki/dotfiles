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
  };

  environment.systemPackages = with pkgs; [
    alacritty
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
    gofumpt
    goimports
    golangci-lint
    gopls
    helix
    jq
    kubectl
    lazygit
    lua-language-server
    markdownlint-cli2
    marksman
    mc
    nil
    nixd
    nixfmt-rfc-style
    nodejs
    python3
    ripgrep
    selene
    statix
    stow
    stylua
    tmux
    tree-sitter
    unzip
    wget
    yarn
    zellij
    zip
    zoxide
  ];
}
