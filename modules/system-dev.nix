{
  pkgs,
  ...
}:
{
  # Language servers and formatters belong to per-project development shells.
  environment.systemPackages = with pkgs; [
    # Nix administration tools, not editor language servers.
    nixfmt
    nixfmt-tree
    statix

    # Runtimes used outside individual projects.
    python3
    nodejs
    uv

    # Tools
    jq
    just
    lazygit
    talosctl
    tree-sitter
  ];
}
