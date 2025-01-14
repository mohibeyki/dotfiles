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

  formatter.${pkgs.system} = nixpkgs.legacyPackages.${pkgs.system}.nixfmt-rfc-style;

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
    gofumpt
    gotools
    golangci-lint
    gopls
    jq
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
