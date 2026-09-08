# Dotfiles

Nix flake-based dotfiles for two hosts:

- `sauron`: NixOS desktop (`x86_64-linux`) with Plasma, Hyprland, NVIDIA, Flatpak, gaming, containers, and Home Manager
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
  - `hyprland.nix` — Hyprland system integration and portal config
  - `nix-ld.nix` — nix-ld runtime libraries for non-Nix binaries/Bazel
  - `nvidia.nix` — NVIDIA driver settings (latest + open kernel module)
  - `game.nix` — gaming settings (Steam, gamescope)
  - `containers.nix` — rootless Docker
  - `greetd.nix` — DMS Greeter display manager config
- `home-modules/` — shared Home Manager modules
  - `onepassword.nix` — 1Password SSH agent + Linux `--silent` user service
  - `ssh.nix` — SSH client Host aliases
  - `llm-env.nix` — load LLM API keys from `~/Documents/llm.conf`
- `home-modules/nixos/` — NixOS-only Home Manager desktop modules
  - `hyprland.nix` + `hypr/*.lua` — Hyprland Lua config and UWSM env
  - `dms.nix` — DankMaterialShell config
  - `theme.nix` — GTK, cursor, Hyprcursor, and Plasma theme settings
- `home-configurations/mohi/` — shared user identity/home settings
- `modules/` — shared system modules
- `darwin-modules/` — Darwin system modules
- `assets/` — repo-managed images/assets

## Desktop notes

- DMS Greeter is the display manager on `sauron`.
- The bundled DMS Greeter launcher is patched locally to use Hyprland's Lua exit dispatcher (`hl.dsp.exit()`); the legacy command leaves greetd waiting for its five-second shutdown timeout. Remove the workaround in `nixos-modules/greetd.nix` once the pinned DMS launcher supports it upstream.
- The Hyprland portal is disabled for the `dms-greeter` account, not for desktop users.
- Plasma and Hyprland are intended to coexist; Hyprland is the primary tiling session.
- UWSM manages Hyprland's environment and lifecycle. DankMaterialShell starts only in that session and supplies its polkit agent; KDE wallet PAM setup is retained.
- Greeter and desktop share monitor definitions.
- `dotfiles.host.monitors` is the source of truth for monitor metadata. Hyprland consumes `desc:...` outputs directly.

## Notes

- Zed is Nix-managed on NixOS and app-managed on Darwin.
- `nixos-modules/nvidia.nix` selects `nvidiaPackages.latest` with the open kernel module.
- **Secrets management** — planned via `agenix`. Not yet implemented; SSH public keys are fine in-repo, but WiFi passwords, VPN configs, and API tokens will need it.
- **Disk encryption** — planned. `/` and `/home` are currently unencrypted. Will add LUKS when reinstalling or migrating.
