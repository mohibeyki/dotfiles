{ pkgs, ... }:
{
  environment.systemPackages =
    (with pkgs; [
      # c/c++
      clang
      clang-tools
      gcc
      cppcheck # linter (nvim-lint)

      # go
      go
      gofumpt
      gopls
      gotools
      golangci-lint # linter (nvim-lint)

      # editor related
      helix
      tree-sitter

      # TS/JS
      bun

      # rust
      cargo-tarpaulin # test coverage (nvim-coverage)

      # python
      ruff # linter/formatter (nvim-lint)

      # etc
      fd
      fzf
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
      vscode-langservers-extracted # json-language-server (schemastore)
      yaml-language-server # yamlls (schemastore)
      zellij # terminal multiplexer
    ])
    ++ (with pkgs.llm-agents; [
      claude-code
      crush
      opencode
      codex
    ]);
}
