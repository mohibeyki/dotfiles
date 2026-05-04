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

    # Needed for pi-agent
    nodejs

    # Tools
    jq
    just
    lazygit
    tree-sitter
  ];
}
