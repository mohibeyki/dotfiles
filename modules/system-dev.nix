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

    # Tools
    jq
    just
    lazygit
    tree-sitter
  ];
}
