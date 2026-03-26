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

      # Go
      go
      gofumpt
      gopls

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
      uv
      ruff
      pyright

      # TOML
      taplo

      # Shell
      shellcheck
      shfmt

      # Zig
      zls

      # Tools
      lazygit
      silicon
      tldr
      zoxide
    ])
    ++ (with pkgs.llm-agents; [
      claude-code
      crush
      opencode
      codex
    ]);
}
