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
│   └── secureboot.nix                     # Secure boot signing
├── home-modules/                          # Home Manager modules (per-user config)
│   ├── common.nix                         # Docker daemon.json, session variables
│   ├── hyprland.nix                       # Hyprland WM: keybinds, env vars, exec-once, settings
│   ├── hyprland-rules.nix                  # Hyprland window rules and layer rules
│   ├── theme.nix                          # GTK/icon/cursor theming + rose-pine-hyprcursor
│   ├── fish.nix, tmux.nix, zellij.nix     # Shell/terminal multiplexers
│   ├── git.nix                            # Git config
│   ├── dev.nix (→ modules/dev.nix)       # Dev tools symlinked to nixos-modules
│   ├── noctalia.nix                       # Noctalia app config
│   ├── helix.nix, zed.nix, ghostty.nix    # Editor/terminal configs
│   └── noctalia.json                      # Noctalia launcher data
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
- `hyprland.nix` uses `hostConfig.monitors`, `hostConfig.workspaces`, `hostConfig.primaryMonitor`, `hostConfig.isNvidia`
- `hyprland-rules.nix` only needs `wayland.windowManager.hyprland.settings` — no special args
- `theme.nix` uses `inputs.rose-pine-hyprcursor` directly
- `dev.nix` does NOT exist as a home module; dev tools are in `modules/dev.nix` (NixOS-only system packages)

### Hyprland Window Rules Pattern
Rules in `hyprland-rules.nix` follow a two-phase pattern:
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
- Hyprland modules are **not** imported on Darwin (no hyprland.nix, hyprland-rules.nix, noctalia.nix, theme.nix, ghostty.nix)

## Pre-commit Hooks

Configured in `flake.nix` per-system:
- `nixfmt` — formats `.nix` files
- `statix` — static analysis for Nix (must be installed in PATH)

Run manually: `nix run .#pre-commit-check`

## Gotchas

- **Home Manager is NOT a user service** — changes only apply after `nixos-rebuild switch`. Do not expect `home-manager` commands to work interactively.
- **`hostConfig` must be passed through** — home modules that need monitor/workspace data receive it via `extraSpecialArgs.hostConfig`. If a module doesn't receive it, check the host's `home-manager.users.mohi.imports`.
- **Hyprland `initial_class` field** — Hyprland renamed `initial_class` to `initialClass` in recent versions. If `hyprland-rules.nix` line 17 causes errors, use `initialClass` instead.
- **`suppress_event` syntax** — Hyprland changed `suppress_event windowclose` to `suppressevent windowclose` (no underscore, camelCase). Check `hyprland-rules.nix` line 88 if errors occur.
- **Darwin has no Hyprland** — only import Hyprland-related modules on NixOS hosts.
- **`dev.nix` is system-only** — dev tools live in `modules/dev.nix` (NixOS system packages), not as a home module.
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
| `nixvim` | NixVim (fork) |
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
