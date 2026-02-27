{ pkgs, inputs, ... }:
{
  environment.systemPackages =
    (with pkgs; [
      # c/c++
      clang
      clang-tools
      gcc

      # go
      go
      gofumpt
      gopls
      gotools

      # editor related
      helix
      tree-sitter

      # TS/JS
      bun

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
      nixd # nix lsp
      nixfmt # nix formatter
      selene # lua linter
      statix # nix linter
      stylua # lua formatter
      taplo # toml toolkit
      zellij # terminal multiplexer
    ])
    ++ (with pkgs.llm-agents; [
      claude-code
      crush
      opencode
      codex
    ])
    ++ [
      inputs.neovim-nightly-overlay.packages.${pkgs.stdenv.hostPlatform.system}.neovim
    ];
}
