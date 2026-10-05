# Dotfiles

Nix flake configurations for two hosts:

- `sauron`: NixOS desktop (`x86_64-linux`) with Hyprland/UWSM, DankMaterialShell, Plasma, NVIDIA, Flatpak, gaming, rootless Docker, and Home Manager.
- `legolas`: macOS (`aarch64-darwin`) with nix-darwin and Home Manager.

Home Manager is integrated into each system configuration; apply home changes with the host rebuild command.

## Apply changes

On `sauron`:

```sh
sudo nixos-rebuild switch --flake .#sauron
```

On `legolas`:

```sh
nix run nix-darwin -- switch --flake .#legolas
```

Update locked inputs with `nix flake update`.

## Validate

Evaluate the host configuration without building it:

```sh
nix eval .#nixosConfigurations.sauron.config.system.build.toplevel.drvPath
nix eval .#darwinConfigurations.legolas.system.drvPath
```

On Linux, `nix flake check` runs the flake's `sauron` host-evaluation check. It does not run formatting or Statix checks. Run those separately:

```sh
nixfmt --check $(rg --files -g '*.nix')
statix check
```

`nix flake check --all-systems` also checks the other platform and therefore needs a builder for it.

## Layout and architecture

- `flake.nix` uses `flake-parts` to expose the NixOS and Darwin configurations, a development shell, and per-system host-evaluation checks.
- `nixos-configurations/sauron/` defines the NixOS host and generated hardware settings.
- `darwin-configurations/legolas/` defines the nix-darwin host.
- `nixos-modules/` contains NixOS system modules for the base system, desktop, Hyprland, DMS Greeter, NVIDIA, gaming, rootless Docker, and nix-ld.
- `darwin-modules/` contains Darwin-specific system settings.
- `modules/` contains shared system settings and system-level development tools.
- `home-configurations/mohi/` defines the shared Home Manager user identity and state version.
- `home-modules/` contains shared Home Manager settings; `home-modules/nixos/` contains Linux desktop settings and the Hyprland Lua configuration.

Coding-agent CLIs from `llm-agents` (including Pi and OpenCode) are installed through `home-modules/user-dev.nix`. Pi is intentionally Nix-managed through `llm-agents`; OpenCode has no custom Home Manager configuration.

The NixOS host imports `home-manager.nixosModules.home-manager`, the NixOS modules, shared modules, and the shared and NixOS-only Home Manager module aggregates. Darwin imports its corresponding Home Manager and Darwin modules. Per-host monitor and workspace data is declared in `nixos-configurations/sauron/default.nix` and exposed through the typed `dotfiles.host` Home Manager option.

Hyprland runs under UWSM. Nix generates `hypr/generated-host.lua` from the host's monitor and workspace settings and writes session-scoped variables to `uwsm/env-hyprland`. DankMaterialShell and the 1Password desktop service start in the Hyprland UWSM session; the latter is ordered after DMS for tray integration.

## Inputs

The current flake inputs are:

| Input | Purpose |
| --- | --- |
| `nixpkgs` | Unstable Nix packages and NixOS modules |
| `flake-parts` | Flake output organization |
| `home-manager` | User configuration on NixOS and Darwin |
| `nix-darwin` | macOS system configuration |
| `hyprland` | Hyprland packages and NixOS integration |
| `nix-flatpak` | Flatpak integration on NixOS |
| `dms` | DankMaterialShell Home Manager module |
| `rose-pine-hyprcursor` | Hyprcursor theme |
| `neovim-nightly-overlay` | Nightly Neovim overlay |
| `llm-agents` | LLM command-line tools |

## Host notes

- `sauron` uses the latest NVIDIA driver package with open kernel modules; this is a deliberate current choice rather than the beta package.
- The NixOS firewall is intentionally disabled for `sauron` as a deliberate home-machine preference.
- The NixOS and Home Manager `stateVersion` values are set in their respective host/user configuration files. Keep existing values when upgrading; they describe compatibility defaults, not the current release.
- NixOS desktop modules are not imported on Darwin.
- Language servers and formatters belong in per-project development shells, not the shared system package list. This flake provides `nix`, `lua`, `python`, `web`, and `writing` shells.
- 1Password provides the SSH agent and Git SSH signing helper. Linux uses `~/.1password/agent.sock`; macOS uses the socket inside the 1Password app group. Incoming SSH sessions preserve their forwarded agent.
- LLM API keys live in `~/.config/llm.conf`, outside the Nix store. Use `KEY=value` lines; Fish loads values literally, so avoid shell substitutions, inline comments, and `export` prefixes.

## Adding modules and packages

- Add a shared Home Manager module to `home-modules/` and import it from `home-modules/default.nix`.
- Add a NixOS-only Home Manager module to `home-modules/nixos/` and import it from `home-modules/nixos/default.nix`.
- Add NixOS system packages to the relevant `nixos-modules/` module or `modules/system-dev.nix`; add Darwin packages to `darwin-modules/default.nix`; add user packages to a Home Manager module.
- Run the relevant host evaluation and formatter/Statix checks. Apply changes with the rebuild command above.
