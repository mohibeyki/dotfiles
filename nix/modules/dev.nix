{ pkgs, inputs, ... }:
{
  environment.systemPackages =
    with pkgs;
    [
      # ai
      claude-code

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

      # editor related
      hx
      tree-sitter

      # etc
      fd
      fzf
      git
      gnumake
      jq # json processor
      lazygit
      libiconv
      lua-language-server
      markdownlint-cli2 # markdown linter
      marksman # markdown lsp
      nixd # nix lsp
      nixfmt-rfc-style # nix formatter
      nodejs
      python3
      ripgrep
      selene # lua linter
      statix # nix linter
      stylua # lua formatter
      taplo # toml toolkit
    ]
    ++ [
      inputs.neovim-nightly-overlay.packages.${pkgs.stdenv.hostPlatform.system}.neovim
    ];
}
