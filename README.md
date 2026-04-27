# Dotfiles

Nix flake-based dotfiles for:
- `sauron`: NixOS desktop
- `legolas`: macOS (`nix-darwin`)

Home Manager is integrated on both platforms.

## Rebuild

NixOS:

```bash
sudo nixos-rebuild switch --flake .#sauron
```

macOS:

```bash
nix run nix-darwin -- switch --flake .#legolas
```

## Validation

```bash
nix flake check --all-systems
```

Note: pre-commit checks are configured through the flake and run via `nix flake check`. They are not installed automatically into `.git/hooks`.

## Layout

- `nixos-configurations/` host configs
- `darwin-configurations/` host configs
- `nixos-modules/` NixOS modules
- `darwin-modules/` Darwin modules
- `home-modules/` Home Manager modules
- `modules/` shared modules
- `assets/` repo-managed images

## Notes

- Hyprland and Noctalia are configured for `sauron`
- Zed is Nix-managed on NixOS and app-managed on Darwin
- secrets management is planned (likely via `agenix`), but it has not been added yet
