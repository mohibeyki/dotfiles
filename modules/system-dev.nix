{
  pkgs,
  ...
}:
{
  environment.systemPackages = with pkgs; [
    # Nix
    nixd
    nixfmt
    nixfmt-tree
    statix

    # Python
    python3
    pyright
    ruff
    uv

    # JavaScript
    nodejs

    # General editor LSPs / formatters (language toolchains stay in devenv)
    lua-language-server
    marksman
    stylua
    taplo
    vscode-langservers-extracted
    yaml-language-server

    # Tools
    jq
    just
    lazygit
    tree-sitter
  ];
}
