{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    btop
    cachix
    fd
    fish
    gcc
    git
    gnumake
    go
    lazygit
    mc
    neovim
    nodejs
    python3
    ripgrep
    stylua
    tree-sitter
    unzip
    wget
    zip
    zoxide
  ];
}
