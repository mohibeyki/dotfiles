{ pkgs, inputs, ... }:
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
    gnumake
    jq # json processor
    libiconv
    lua-language-server
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
  ] ++ [
    inputs.neovim-nightly-overlay.packages.${pkgs.stdenv.hostPlatform.system}.neovim
  ];
}
