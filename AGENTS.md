# Agent Guidance — Mohi's NixOS/Home Manager Dotfiles

## Project Overview

Nix flake-based dotfiles managing two hosts:
- **`sauron`**: NixOS desktop (x86_64-linux) with Plasma, Hyprland, Niri, and NVIDIA GPU
- **`legolas`**: macOS (`nix-darwin`, aarch64-darwin)

Home Manager runs **only during rebuilds**, not as a user service (`startAsUserService = false`).

## Rebuild Commands

```bash
# NixOS (sauron)
sudo nixos-rebuild switch --flake .#sauron

# macOS (legolas)
nix run nix-darwin -- switch --flake .#legolas

# Update flake inputs
nix flake update

# Evaluate a configuration
nix eval .#nixosConfigurations.sauron.config.system.build.toplevel.drvPath

# Dry-run build a configuration
nix build .#nixosConfigurations.sauron.config.system.build.toplevel --dry-run --no-link
```

## Directory Structure

```
.
├── flake.nix                              # Flake entry point; ez-configs + pre-commit hooks
├── flake.lock                             # Lock file for all inputs
├── nixos-modules/                         # NixOS system-level modules
│   ├── default.nix                        # Aggregates NixOS modules for sauron
│   ├── base.nix                           # Core system config (boot, i18n, users, services)
│   ├── desktop.nix                        # Plasma, desktop apps, graphics, MIME/menu integration
│   ├── hyprland.nix                       # Hyprland system config
│   ├── niri.nix                           # Niri system config and supporting packages
│   ├── nix-ld.nix                         # nix-ld runtime libraries for non-Nix binaries/Bazel
│   ├── nvidia.nix                         # NVIDIA GPU + DRM kernel params
│   ├── game.nix                           # Gaming settings (gamescope, Steam, etc.)
│   ├── containers.nix                     # Docker/Podman containers
│   └── sddm.nix                           # SDDM display manager config
├── home-modules/                          # Home Manager modules (per-user config)
│   ├── common.nix                         # session variables, shared tools
│   ├── user-dev.nix                       # User-level dev tool packages
│   ├── fish.nix, tmux.nix, zellij.nix     # Shell/terminal multiplexers
│   ├── git.nix                            # Git config
│   ├── helix.nix, zed.nix, ghostty.nix    # Editor/terminal configs
│   ├── zellij.kdl                         # Zellij layout/UI config
│   └── nixos/                             # NixOS-only home modules
│       ├── hyprland.nix                   # Hyprland WM: keybinds, env vars, exec-once, settings
│       ├── hyprland-rules.nix             # Hyprland window rules and layer rules
│       ├── niri.nix                       # Niri config.kdl generated from Nix
│       ├── theme.nix                      # GTK/icon/cursor theming + rose-pine-hyprcursor + Plasma theme
│       └── noctalia.nix                   # Noctalia app config
├── nixos-configurations/sauron/           # Sauron host (NixOS) entry point
│   ├── default.nix                        # Host imports + NixOS/HM module list
│   └── hardware.nix                       # Hardware config from nixos-generate-config
├── darwin-configurations/legolas/         # Legolas host (macOS) entry point
│   └── default.nix                        # Host imports + darwin/home-manager module list
├── home-configurations/mohi/              # Shared home config (username, homeDirectory, stateVersion)
│   └── default.nix
├── modules/                               # Shared modules (imported by both NixOS and Darwin)
│   ├── shared.nix                         # Nix settings, fonts, system packages
│   └── system-dev.nix                     # Dev tool packages (clang, go, rust/fenix, node, etc.)
└── darwin-modules/                        # Darwin-specific system modules
    └── default.nix
```

## Architecture & Control Flow

### Flake Entry Point (`flake.nix`)
- Uses `flake-parts` with `ez-configs` for declarative host/home config
- Passes `inputs` as `extraSpecialArgs` to all configurations
- Supports two systems: `x86_64-linux` and `aarch64-darwin`
- Pre-commit hooks: `nixfmt` + `statix` (both enabled)

### Host Configs (`nixos-configurations/*/`, `darwin-configurations/*/`)
- Each host imports:
  1. `home-manager.nixosModules.home-manager` (NixOS) or HM standalone (Darwin)
  2. Platform modules (`nixos-modules/`, `darwin-modules/`)
  3. Shared modules (`modules/`)
  4. Home modules (`home-modules/`)
- `dotfiles.host` Home Manager option carries per-host data:
  - `isNvidia` — whether to set NVIDIA env vars
  - `monitors` — monitor configs (output, mode, position, scale, bitdepth, vrr, cm, optional icc)
  - `workspaces` — Hyprland workspace-to-monitor mappings
  - `gitSigningKey` — SSH signing key for commits

### Home Modules
- Most home modules read `config.dotfiles.host` to adapt to host
- `nixos/hyprland.nix` uses `config.dotfiles.host.monitors`, `config.dotfiles.host.workspaces`, and `config.dotfiles.host.isNvidia`
- `nixos/hyprland-rules.nix` only needs `wayland.windowManager.hyprland.settings` — no host option access
- `nixos/niri.nix` uses `config.dotfiles.host.monitors` and `config.dotfiles.host.isNvidia`, and mirrors the Hyprland monitor/workspace/keybinding model where Niri supports it
- `nixos/theme.nix` uses `inputs.rose-pine-hyprcursor` directly and configures Plasma colors via plasma-manager
- `nixvim.nix` uses `inputs.nixvim` directly for the nixvim package

### Window Manager Config Patterns
Hyprland rules in `nixos/hyprland-rules.nix` follow a two-phase pattern:
1. **Tag assignment**: `windowrule "tag +<name>, match:class ^(...)"` assigns windows to logical tags
2. **Tag rules**: `windowrule "<action> on, match:tag <name>"` applies behaviors to all windows with that tag

Niri configuration in `nixos/niri.nix` is generated as raw KDL at `~/.config/niri/config.kdl`. It uses named workspaces (`"1"` through `"10"`) to mimic Hyprland's persistent workspace layout.

## Key Conventions

### Module Imports in Hosts
```nix
# In sauron/default.nix:
home-manager.users.mohi.imports = [
  inputs.noctalia-shell.homeModules.default  # external flake input
  inputs.plasma-manager.homeModules.plasma-manager
  ../../home-configurations/mohi             # local home config
  ../../home-modules                         # shared HM module aggregate
  ../../home-modules/nixos                   # NixOS-only HM module aggregate
];
```

### Nixpkgs Overlays
Overlays are composed at the host level and passed via `extraSpecialArgs.overlays`:
```nix
# sauron overlays example
sauronOverlays = [
  (final: prev: { btop = prev.btop.override { cudaSupport = true; }; })
];
```

### Monitor Config
Host monitor definitions use `desc:...` (EDID description) for identification. Hyprland consumes these directly via `monitorv2`. Niri strips the `desc:` prefix and matches outputs by manufacturer/model/serial. The `vrr` field is stored as the integer value Hyprland expects (for example `0`, `1`, or `2`); Niri treats any non-zero value as on-demand VRR.

### Darwin-Specific
- `stateVersion` uses integers (`6`) not strings
- `nixpkgs.hostPlatform = "aarch64-darwin"` explicitly sets host platform
- NixOS desktop modules (`nixos/hyprland.nix`, `nixos/hyprland-rules.nix`, `nixos/niri.nix`, `nixos/noctalia.nix`, `nixos/theme.nix`) are **not** imported on Darwin

## Pre-commit Hooks

Configured in `flake.nix` per-system:
- `nixfmt` — formats `.nix` files
- `statix` — static analysis for Nix (must be installed in PATH)

Run manually:
- Linux: `nix build .#checks.x86_64-linux.pre-commit --no-link`
- Darwin: `nix build .#checks.aarch64-darwin.pre-commit --no-link`

## Gotchas

- **Home Manager is NOT a user service** — changes only apply after `nixos-rebuild switch`. Do not expect `home-manager` commands to work interactively.
- **`dotfiles.host` must be set per host** — home modules that need monitor/workspace/signing data read it from the Home Manager option tree. If a module is missing data, check `home-manager.users.mohi.dotfiles.host` in the host config.
- **Darwin has no Linux desktop stack** — only import Hyprland/Niri/Noctalia/theme desktop modules on NixOS hosts.
- **Dev tools have two modules** — system-level dev tools are in `modules/system-dev.nix`; user-level dev tools are in `home-modules/user-dev.nix`. `nixos-modules/nix-ld.nix` exists separately for dynamic linker compatibility with non-Nix binaries/Bazel.
- **Nix repl/lsp requires `nixd`** — use `nixd` for Nix language server. `statix` in pre-commit is a separate binary.
- **No auto-commit** — user commits manually. Never push or commit without being asked.

## External Inputs (from `flake.nix`)

| Input | Purpose |
|-------|---------|
| `nixpkgs` | nixpkgs-unstable |
| `home-manager` | HM for both NixOS and Darwin |
| `nix-darwin` | Darwin system configuration |
| `hyprland` | Hyprland WM (nixosModules) |
| `flake-parts` | Flake module system |
| `ez-configs` | Declarative host/home config |
| `fenix` | Rust toolchain via overlay |
| `nixvim` | NixVim (fork) — installed via `home-modules/nixvim.nix` |
| `rose-pine-hyprcursor` | Hyprcursor theme |
| `llm-agents.nix` | LLM CLI tools (claude-code, copilot-cli, etc.) |
| `noctalia-qs` / `noctalia-shell` | Noctalia app |
| `plasma-manager` | KDE Plasma configuration via Home Manager |
| `nix-flatpak` | Flatpak integration for NixOS |
| `git-hooks.nix` | Pre-commit hooks |

## Adding a New Home Module

1. Create `home-modules/<name>.nix` — takes at minimum `{ pkgs, ... }` or `{ config, lib, pkgs, ... }` if it needs host-specific data from `config.dotfiles.host`
2. If shared by both hosts, add it to `home-modules/default.nix`
3. If NixOS-only, add it to `home-modules/nixos/default.nix`
4. Only edit a host's `home-manager.users.mohi.imports` list when adding a new aggregate module tree or external Home Manager module
5. Run rebuild — no separate home-manager switch needed

## Adding a New System Package

- **NixOS system package**: add to the most specific module under `nixos-modules/` (`desktop.nix`, `game.nix`, `niri.nix`, etc.) or to `modules/system-dev.nix` if it is a dev tool
- **Darwin system package**: add to `darwin-modules/default.nix`
- **User package**: add to appropriate `home-modules/<name>.nix` under `home.packages`

## Known Issues / Pending

- **NVIDIA beta driver workaround**: `nixos-modules/nvidia.nix` overrides the selected beta driver to provide `makeFlags = old.makeFlags or [ ];` because current nixpkgs `nvidia-persistenced` expects `nvidia_x11.makeFlags`.
- **Niri output names**: if monitor matching fails after hardware/EDID changes, log into Niri and check `niri msg outputs`; update the stripped `desc:` names in `home-modules/nixos/niri.nix` if needed.
