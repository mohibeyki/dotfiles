{
  pkgs,
  ...
}:
{
  programs.nix-ld = {
    enable = true;
    libraries = with pkgs; [
      bzip2
      curl
      libffi
      libxml2
      ncurses
      openssl
      sqlite
      stdenv.cc.cc
      xz
      zlib
      zstd
    ];
  };

  environment.systemPackages = with pkgs; [
    # C/C++
    clang
    clang-tools
    cmake
    lldb
    gnumake
    cpplint

    # Go
    go
    gofumpt
    golangci-lint
    gopls
    gotools

    # JSON / HTML / CSS
    vscode-langservers-extracted

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
    nixfmt-tree
    statix

    # Python
    pyright
    ruff
    uv

    # Rust (toolchain + LSP via fenix overlay for version coherence)
    fenix.stable.toolchain

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
    yaml-language-server
    yamlfmt
    yamllint

    # Zig
    zls

    # Tools
    cachix
    ghostscript
    glib
    imagemagick
    lazygit
    mermaid-cli
    prettier
    prettierd
    silicon
    tldr
    trash-cli
    tree-sitter
  ];
}
