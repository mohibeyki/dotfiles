{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    # c/c++
    clang
    clang-tools
    gcc

    # go
    go
    gofumpt
    gopls
    gotools

    # rust
    cargo
    clippy
    rust-analyzer
    rustc

    # zig
    zig

    # etc
    lua-language-server
    gnumake
    markdownlint-cli2 # markdown linter
    marksman # markdown lsp
    nixd # nix lsp
    nixfmt-rfc-style # nix formatter
    nodejs
    python3
    selene # lua linter
    statix # nix linter
    stylua # lua formatter
    taplo # toml toolkit
    tree-sitter
  ];
}
