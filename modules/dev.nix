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
      pyright
      ruff
      uv

      # Rust (toolchain + LSP via fenix overlay for version coherence)
      fenix.stable.toolchain
      fenix.stable.rust-analyzer

      # Shell
      shellcheck
      shfmt

      # TOML
      taplo

      # TypeScript
      bun
      esbuild
      eslint
      nodejs
      pnpm
      tsx
      typescript
      typescript-language-server
      yarn

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
      tldr
      trash-cli
      tree-sitter
      zoxide
    ])
    ++ (with pkgs.llm-agents; [
      claude-code
      codex
      copilot-cli
      crush
      gemini-cli
      opencode
    ]);
}
