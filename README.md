# Dotfiles

Nix flake-based dotfiles for two hosts:

- `sauron`: NixOS desktop (`x86_64-linux`) with Plasma, Hyprland, Niri, NVIDIA, Flatpak, gaming, containers, and Home Manager
- `legolas`: macOS (`nix-darwin`, `aarch64-darwin`) with Home Manager

Home Manager is integrated into system rebuilds on both platforms; there is no separate interactive `home-manager switch` workflow.

## Rebuild

NixOS (`sauron`):

```bash
sudo nixos-rebuild switch --flake .#sauron
```

macOS (`legolas`):

```bash
nix run nix-darwin -- switch --flake .#legolas
```

Update inputs:

```bash
nix flake update
```

## Validation

Evaluate the NixOS system derivation:

```bash
nix eval .#nixosConfigurations.sauron.config.system.build.toplevel.drvPath
```

Dry-run build the NixOS system:

```bash
nix build .#nixosConfigurations.sauron.config.system.build.toplevel --dry-run --no-link
```

Run flake checks, including pre-commit checks:

```bash
nix flake check --all-systems
```

Pre-commit hooks are configured through the flake (`nixfmt` and `statix`) and are not installed automatically into `.git/hooks`.

## Layout

- `flake.nix` — flake entry point, `flake-parts`, `ez-configs`, pre-commit hooks
- `nixos-configurations/sauron/` — NixOS host config and hardware config
- `darwin-configurations/legolas/` — nix-darwin host config
- `nixos-modules/` — NixOS modules
  - `base.nix` — boot, users, services, networking, PipeWire, polkit
  - `desktop.nix` — Plasma, desktop packages, graphics, MIME/menu integration
  - `hyprland.nix` — Hyprland system integration
  - `niri.nix` — Niri system integration and supporting tools
  - `nix-ld.nix` — nix-ld runtime libraries for non-Nix binaries/Bazel
  - `nvidia.nix` — NVIDIA driver settings (beta + open kernel module)
  - `game.nix` — gaming settings (Steam, gamescope, gamemode)
  - `containers.nix` — Docker/Podman containers
  - `sddm.nix` — SDDM display manager config
- `home-modules/` — shared Home Manager modules
- `home-modules/nixos/` — NixOS-only Home Manager desktop modules
  - `hyprland.nix` / `hyprland-rules.nix` — Hyprland settings and rules
  - `niri.nix` — generated Niri `config.kdl`
  - `noctalia.nix` — Noctalia config
  - `theme.nix` — GTK, cursor, Hyprcursor, and Plasma theme settings
- `home-configurations/mohi/` — shared user identity/home settings
- `modules/` — shared system modules and keys
- `darwin-modules/` — Darwin system modules
- `assets/` — repo-managed images/assets

## Desktop notes

- SDDM is the display manager on `sauron`.
- Plasma, Hyprland, and Niri are intended to coexist.
- Hyprland and Niri both start Noctalia, 1Password, KDE wallet setup, and the KDE polkit agent.
- `dotfiles.host.monitors` is the source of truth for monitor metadata. Hyprland consumes `desc:...` outputs directly; Niri strips `desc:` and matches outputs by manufacturer/model/serial.
- Niri uses persistent named workspaces (`"1"` through `"10"`) to mimic the Hyprland workspace layout.

## Notes

- Zed is Nix-managed on NixOS and app-managed on Darwin.
- `nixos-modules/nvidia.nix` selects `nvidiaPackages.beta` with the open kernel module.
- **Secrets management** — planned via `agenix`. Not yet implemented; SSH public keys are fine in-repo, but WiFi passwords, VPN configs, and API tokens will need it.
- **Disk encryption** — planned. `/` and `/home` are currently unencrypted. Will add LUKS when reinstalling or migrating.
