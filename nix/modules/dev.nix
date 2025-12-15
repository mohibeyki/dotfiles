{ pkgs, inputs, ... }:
{
  environment.systemPackages =
    with pkgs;
    [
      # ai
      claude-code
      crush

      # c/c++
      clang
      clang-tools
      gcc

      # go
      go
      gofumpt
      gopls
      gotools

      # zig
      zig
      zls

      # editor related
      helix
      tree-sitter

      # etc
      fd
      fzf
      git
      gnumake
      jq # json processor
      lazygit
      libiconv
      lldb
      nodejs
      python3
      ripgrep

      # LSPs
      lua-language-server
      markdownlint-cli2 # markdown linter
      marksman # markdown lsp
      nixd # nix lsp
      nixfmt-rfc-style # nix formatter
      selene # lua linter
      statix # nix linter
      stylua # lua formatter
      taplo # toml toolkit
      zellij # terminal multiplexer
    ]
    ++ [
      inputs.neovim-nightly-overlay.packages.${pkgs.stdenv.hostPlatform.system}.neovim
    ];
}
