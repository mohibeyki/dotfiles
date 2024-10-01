{ pkgs, inputs, ... }:
{
  nixpkgs.overlays = [
    inputs.neovim-nightly-overlay.overlays.default
  ];

  nix = {
    package = pkgs.nixVersions.latest; # pkgs.nix;

    # Trusted users for cachix
    settings.trusted-users = [ "root" "mohi" ];

    # Necessary for using flakes on this system.
    settings.experimental-features = [ "nix-command" "flakes" ];
  };

  # Enable non-free applications
  nixpkgs.config.allowUnfree = true;

  # Create /etc/zshrc that loads the nix-darwin environment.
  programs.zsh.enable = true;

  # Enable fish and fix nix packages' order on the PATH
  programs.fish.enable = true;

  environment.systemPackages = with pkgs; [
    bc
    btop
    cachix
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
    mc
    neofetch
    neovim
    nil
    nixpkgs-fmt
    nodejs
    python3
    ripgrep
    selene
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
