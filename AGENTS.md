# Agent Guidance — Mohi's NixOS/Home Manager Dotfiles

## Project Overview

Nix flake-based dotfiles managing two hosts:
- **`sauron`**: NixOS desktop (x86_64-linux) with Hyprland, NVIDIA GPU
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

# Dry-run evaluate a configuration
nix eval .#nixosConfigurations.sauron.config.system.build.toplevel.drvPath --dry-run
```

## Directory Structure

```
.
├── flake.nix                              # Flake entry point; ez-configs + pre-commit hooks
├── flake.lock                             # Lock file for all inputs
├── nixos-modules/                         # NixOS system-level modules
│   ├── default.nix                        # Core system config (boot, i18n, users, services)
│   ├── desktop.nix                        # Display manager, desktop packages
│   ├── hyprland.nix                       # Hyprland system config (portals, etc.)
│   ├── nvidia.nix                         # NVIDIA GPU + DRM kernel params
│   ├── game.nix                           # Gaming settings (gamescope, etc.)
│   ├── containers.nix                     # Podman/Docker containers
│   └── sddm.nix                           # SDDM display manager config
├── home-modules/                          # Home Manager modules (per-user config)
│   ├── common.nix                         # nixvim, xdg-terminal-exec, session variables
│   ├── dev.nix                            # User-level dev tool packages
│   ├── fish.nix, tmux.nix, zellij.nix     # Shell/terminal multiplexers
│   ├── git.nix                            # Git config
│   ├── helix.nix, zed.nix, ghostty.nix    # Editor/terminal configs
│   ├── zellij.kdl                         # Zellij layout/UI config
│   └── nixos/                             # NixOS-only home modules
│       ├── hyprland.nix                   # Hyprland WM: keybinds, env vars, exec-once, settings
│       ├── hyprland-rules.nix              # Hyprland window rules and layer rules
│       ├── theme.nix                      # GTK/icon/cursor theming + rose-pine-hyprcursor
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
│   └── dev.nix                            # Dev tool packages (clang, go, rust/fenix, node, etc.)
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
- `hostConfig` attribute set in `home-manager.extraSpecialArgs` carries per-host data:
  - `isNvidia` — whether to set NVIDIA env vars
  - `monitors` — monitor configs (output, mode, position, scale, bitdepth, vrr, cm)
  - `workspaces` — workspace-to-monitor mappings
  - `primaryMonitor` — primary monitor output name
  - `gitSigningKey` — SSH signing key for commits

### Home Modules
- Most home modules take `hostConfig` from `extraSpecialArgs` to adapt to host
- `nixos/hyprland.nix` uses `hostConfig.monitors`, `hostConfig.workspaces`, `hostConfig.primaryMonitor`, `hostConfig.isNvidia`
- `nixos/hyprland-rules.nix` only needs `wayland.windowManager.hyprland.settings` — no special args
- `nixos/theme.nix` uses `inputs.rose-pine-hyprcursor` directly
- `common.nix` uses `inputs.nixvim` directly for the nixvim package

### Hyprland Window Rules Pattern
Rules in `nixos/hyprland-rules.nix` follow a two-phase pattern:
1. **Tag assignment**: `windowrule "tag +<name>, match:class ^(...)"` assigns windows to logical tags
2. **Tag rules**: `windowrule "<action> on, match:tag <name>"` applies behaviors to all windows with that tag

## Key Conventions

### Module Imports in Hosts
```nix
# In sauron/default.nix:
home-manager.users.mohi.imports = [
  inputs.noctalia-shell.homeModules.default  # external flake input
  ../../home-configurations/mohi             # local home config
  ../../home-modules/common.nix              # local home modules
  # ... more home modules
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

### Hyprland Monitor Config
Monitors use `desc:...` (EDID description) for identification. The `vrr` field maps to integer (0/1) in the settings:
```nix
vrr = if monitor.vrr then 1 else 0;
```

### Darwin-Specific
- `stateVersion` uses integers (`6`) not strings
- `nixpkgs.hostPlatform = "aarch64-darwin"` explicitly sets host platform
- Hyprland-specific modules (`nixos/hyprland.nix`, `nixos/hyprland-rules.nix`, `nixos/noctalia.nix`, `nixos/theme.nix`) are **not** imported on Darwin

## Pre-commit Hooks

Configured in `flake.nix` per-system:
- `nixfmt` — formats `.nix` files
- `statix` — static analysis for Nix (must be installed in PATH)

Run manually:
- Linux: `nix build .#checks.x86_64-linux.pre-commit --no-link`
- Darwin: `nix build .#checks.aarch64-darwin.pre-commit --no-link`

## Gotchas

- **Home Manager is NOT a user service** — changes only apply after `nixos-rebuild switch`. Do not expect `home-manager` commands to work interactively.
- **`hostConfig` must be passed through** — home modules that need monitor/workspace data receive it via `extraSpecialArgs.hostConfig`. If a module doesn't receive it, check the host's `home-manager.users.mohi.imports`.
- **Darwin has no Hyprland** — only import Hyprland-related modules on NixOS hosts.
- **Dev tools have two modules** — system-level dev tools are in `modules/dev.nix`; user-level dev tools are in `home-modules/dev.nix`. Both exist.
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
| `nixvim` | NixVim (fork) — used in `common.nix` |
| `rose-pine-hyprcursor` | Hyprcursor theme |
| `llm-agents.nix` | LLM CLI tools (claude-code, copilot-cli, etc.) |
| `noctalia-qs` / `noctalia-shell` | Noctalia app |
| `nix-flatpak` | Flatpak integration for NixOS |
| `pre-commit-hooks.nix` | Pre-commit hooks |

## Adding a New Home Module

1. Create `home-modules/<name>.nix` — takes at minimum `{ pkgs, ... }` or `{ hostConfig, lib, pkgs, ... }` if it needs host-specific data
2. Add to the host's `home-manager.users.mohi.imports` list in the appropriate config file
3. For NixOS: add to `nixos-configurations/sauron/default.nix`
4. For Darwin: add to `darwin-configurations/legolas/default.nix`
5. Run rebuild — no separate home-manager switch needed

## Adding a New System Package

- **NixOS system package**: add to `nixos-modules/default.nix` or `modules/dev.nix` (if dev tool)
- **Darwin system package**: add to `darwin-modules/default.nix`
- **User package**: add to appropriate `home-modules/<name>.nix` under `home.packages`

## Known Issues / Pending

- **`nixos/hyprland-rules.nix`** (lines 17, 81): `initial_class` and `suppress_event` fields may be invalid — user needs to verify against Hyprland documentation and decide whether to remove or fix
