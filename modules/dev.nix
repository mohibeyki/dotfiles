{ pkgs, ... }:
{
  environment.systemPackages =
    (with pkgs; [
      # C/C++
      clang
      clang-tools
      cmake
      gdb
      gnumake
      cpplint

      # Go
      go
      gofumpt
      golangci-lint
      gopls
      gotools

      # Lua
      lua-language-server
      stylua

      # Markdown
      glow
      markdownlint-cli
      marksman

      # Nix
      manix
      nix-output-monitor
      nixd
      nixfmt
      statix

      # Python
      black
      pylint
      pyright
      ruff
      uv

      # Shell
      shellcheck
      shfmt

      # TOML
      taplo

      # YAML
      yamlfmt
      yamllint

      # Zig
      zls

      # Tools
      ghostscript
      imagemagick
      lazygit
      mermaid-cli
      prettier
      prettierd
      silicon
      sqlite
      tldr
      trash-cli
      tree-sitter
      zoxide
    ])
    ++ (with pkgs.llm-agents; [
      claude-code
      crush
      opencode
      codex
    ]);
}
