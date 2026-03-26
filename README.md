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
- `agenix` is kept for future secrets setup
