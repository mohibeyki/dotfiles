{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    btop
    cargo
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
    rust-analyzer
    rustc
    stylua
    tree-sitter
    unzip
    wget
    zip
    zoxide
  ];
}
