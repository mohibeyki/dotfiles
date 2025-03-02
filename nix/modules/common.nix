{
  pkgs,
  ...
}:
{
  ids.gids.nixbld = 350;

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
    bc # calculator
    btop
    cachix
    clang-tools
    fd
    fishPlugins.tide
    fzf
    gcc
    gcc-arm-embedded
    git
    gnumake
    gnused
    go
    gofumpt
    gopls
    gotools
    jq # json processor
    lazygit
    libiconv
    lua-language-server
    markdownlint-cli2 # markdown linter
    marksman # markdown lsp
    mc
    nixd # nix lsp
    nixfmt-rfc-style # nix formatter
    nodejs
    python3
    qmk
    ripgrep
    selene # lua linter
    statix # nix linter
    stylua # lua formatter
    taplo # toml toolkit
    tmux
    tree-sitter
    unzip
    wget
    xz
    yarn
    zellij
    zip
    zoxide
  ];
}
