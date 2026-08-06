# Agent Guidance — Mohi's NixOS/Home Manager Dotfiles

## Project Overview

Nix flake-based dotfiles managing two hosts:
- **`sauron`**: NixOS desktop (x86_64-linux) with Plasma, Hyprland, and NVIDIA GPU
- **`legolas`**: macOS (`nix-darwin`, aarch64-darwin)

Home Manager is integrated into system rebuilds on both platforms. There is no separate interactive `home-manager switch` workflow — apply changes with the host rebuild commands below.

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
│   ├── nix-ld.nix                         # nix-ld runtime libraries for non-Nix binaries/Bazel
│   ├── nvidia.nix                         # NVIDIA GPU + DRM kernel params
│   ├── game.nix                           # Gaming settings (gamescope, Steam, etc.)
│   ├── containers.nix                     # Docker/Podman containers
│   └── sddm.nix                           # SDDM display manager config
├── home-modules/                          # Home Manager modules (per-user config)
│   ├── common.nix                         # session variables, shared tools
│   ├── user-dev.nix                       # User-level dev tool packages
│   ├── host-config.nix                    # Typed dotfiles.host options
│   ├── fish.nix, tmux.nix, zellij.nix     # Shell/terminal multiplexers
│   ├── git.nix                            # Git config
│   ├── helix.nix, zed.nix, ghostty.nix    # Editor/terminal configs
│   ├── neovim.nix                         # Neovim (nightly via overlay) + aliases
│   ├── opencode.nix                       # opencode permissions and config
│   ├── zellij.kdl                         # Zellij layout/UI config
│   └── nixos/                             # NixOS-only home modules
│       ├── hyprland.nix                   # Hyprland HM: env, portals, generated host.lua
│       ├── hypr/                          # Hyprland Lua config (binds, rules, settings)
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
│   └── system-dev.nix                     # System-level dev tools + general LSPs/formatters
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
  1. `home-manager.nixosModules.home-manager` (NixOS) or HM via darwin modules
  2. Platform modules (`nixos-modules/`, `darwin-modules/`)
  3. Shared modules (`modules/`)
  4. Home modules (`home-modules/`)
- `dotfiles.host` Home Manager option carries per-host data:
  - `isNvidia` — whether to set NVIDIA env vars
  - `monitors` — monitor configs (output, mode, position, scale, bitdepth, vrr, cm, optional icc)
  - `workspaces` — structured Hyprland workspace rules (`id`, `monitor`, `default`, `persistent`)
  - `gitSigningKey` — SSH signing key for commits
  - `shell` — optional shell/launcher (`noctalia` or null)

### Home Modules
- Most home modules read `config.dotfiles.host` to adapt to host
- `nixos/hyprland.nix` uses `config.dotfiles.host.monitors`, `workspaces`, `isNvidia`, and `shell`; writes `hypr/*.lua` and `hypr/generated-host.lua`
- `nixos/theme.nix` uses `inputs.rose-pine-hyprcursor` and configures Plasma colors via plasma-manager

### Window Manager Config Patterns
Hyprland is configured in Lua under `home-modules/nixos/hypr/`:
1. **Host data** — Nix generates `hypr/generated-host.lua` (monitors, workspaces, env)
2. **Rules** — `hypr/rules.lua` uses a two-phase pattern: tag assignment by class, then tag-based actions
3. **Binds / settings** — `hypr/binds.lua` (plus optional `binds-noctalia.lua`) and `hypr/settings.lua`

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
Host monitor definitions use `desc:...` (EDID description) for identification. Hyprland consumes these directly via `monitorv2`. The `vrr` field is stored as the integer value Hyprland expects (for example `0`, `1`, or `2`).

### Darwin-Specific
- `stateVersion` uses integers (`6`) not strings
- `nixpkgs.hostPlatform = "aarch64-darwin"` explicitly sets host platform
- NixOS desktop modules (`nixos/hyprland.nix`, `nixos/hypr/`, `nixos/noctalia.nix`, `nixos/theme.nix`) are **not** imported on Darwin

## Pre-commit Hooks

Configured in `flake.nix` per-system:
- `nixfmt` — formats `.nix` files
- `statix` — static analysis for Nix (must be installed in PATH)

Run manually:
- Linux: `nix build .#checks.x86_64-linux.pre-commit --no-link`
- Darwin: `nix build .#checks.aarch64-darwin.pre-commit --no-link`

## Gotchas

- **Home Manager applies on system rebuild** — changes only take effect after `nixos-rebuild switch` (or the darwin equivalent). Do not expect a separate interactive `home-manager switch` workflow.
- **`dotfiles.host` must be set per host** — home modules that need monitor/workspace/signing data read it from the Home Manager option tree. If a module is missing data, check `home-manager.users.mohi.dotfiles.host` in the host config.
- **Darwin has no Linux desktop stack** — only import Hyprland/Noctalia/theme desktop modules on NixOS hosts.
- **Dev tools have two modules** — system-level dev tools are in `modules/system-dev.nix`; user-level dev tools are in `home-modules/user-dev.nix`. `nixos-modules/nix-ld.nix` exists separately for dynamic linker compatibility with non-Nix binaries/Bazel.
- **Nix repl/lsp requires `nixd`** — use `nixd` for Nix language server. `statix` in pre-commit is a separate binary.
- **No auto-commit** — user commits manually. Never push or commit without being asked.

## External Inputs (from `flake.nix`)

| Input | Purpose |
|-------|---------|
| `nixpkgs` | nixpkgs-unstable |
| `home-manager` | HM for both NixOS and Darwin |
| `nix-darwin` | Darwin system configuration |
| `hyprland` | Hyprland WM (does not follow nixpkgs; uses upstream cache) |
| `flake-parts` | Flake module system |
| `ez-configs` | Declarative host/home config |
| `neovim-nightly-overlay` | Nightly Neovim package |
| `rose-pine-hyprcursor` | Hyprcursor theme |
| `llm-agents` | LLM CLI tools (opencode, grok, etc.) |
| `noctalia-shell` | Noctalia shell (cachix branch) |
| `plasma-manager` | KDE Plasma configuration via Home Manager |
| `nix-flatpak` | Flatpak integration for NixOS |
| `nix-gaming` | Gaming platform optimizations |
| `git-hooks` | Pre-commit hooks |
| `nix-index-database` | Prebuilt nix-index DB for comma |

## Adding a New Home Module

1. Create `home-modules/<name>.nix` — takes at minimum `{ pkgs, ... }` or `{ config, lib, pkgs, ... }` if it needs host-specific data from `config.dotfiles.host`
2. If shared by both hosts, add it to `home-modules/default.nix`
3. If NixOS-only, add it to `home-modules/nixos/default.nix`
4. Only edit a host's `home-manager.users.mohi.imports` list when adding a new aggregate module tree or external Home Manager module
5. Run rebuild — no separate home-manager switch needed

## Adding a New System Package

- **NixOS system package**: add to the most specific module under `nixos-modules/` (`desktop.nix`, `game.nix`, etc.) or to `modules/system-dev.nix` if it is a dev tool
- **Darwin system package**: add to `darwin-modules/default.nix`
- **User package**: add to appropriate `home-modules/<name>.nix` under `home.packages`

## Known Issues / Pending

- **NVIDIA latest driver**: `nixos-modules/nvidia.nix` selects `nvidiaPackages.latest` with the open kernel module.
