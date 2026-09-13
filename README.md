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

Evaluate the host for this machine (also runs as `checks.host-eval` under `nix flake check`):

```bash
# Linux
nix eval .#nixosConfigurations.sauron.config.system.build.toplevel.drvPath

# macOS
nix eval .#darwinConfigurations.legolas.system.drvPath
```

Dry-run build the NixOS system:

```bash
nix build .#nixosConfigurations.sauron.config.system.build.toplevel --dry-run --no-link
```

Run flake checks for the current system (pre-commit plus host eval):

```bash
nix flake check
```

`--all-systems` also builds the other platform's checks, which needs that system's builder. Evaluating a host's derivation alone does not need a builder for that platform. Pre-commit hooks (`nixfmt`, `statix`) live in the flake and are not installed into `.git/hooks` automatically.

## Layout

- `flake.nix` — flake entry point, `flake-parts`, `ez-configs`, pre-commit hooks
- `nixos-configurations/sauron/` — NixOS host config and hardware config
- `darwin-configurations/legolas/` — nix-darwin host config
- `nixos-modules/` — NixOS modules
  - `base.nix` — boot, users, services, networking, PipeWire, polkit
  - `desktop.nix` — Plasma, desktop packages, graphics, MIME/menu integration
  - `hyprland.nix` — Hyprland system integration and portal config
  - `nix-ld.nix` — nix-ld runtime libraries for non-Nix binaries/Bazel
  - `nvidia.nix` — NVIDIA latest + open kernel module (not loaded in initrd)
  - `game.nix` — gaming settings (Steam, gamescope)
  - `containers.nix` — rootless Docker
  - `greetd.nix` — DMS Greeter display manager config
- `home-modules/` — shared Home Manager modules
  - `onepassword.nix` — 1Password SSH agent + Linux `--silent` user service
  - `ssh.nix` — SSH client Host aliases
  - `git.nix` — Git config and SSH commit signing via 1Password
  - `llm-env.nix` — load LLM API keys from `~/.config/llm.conf`
- `home-modules/nixos/` — NixOS-only Home Manager desktop modules
  - `hyprland.nix` + `hypr/*.lua` — Hyprland Lua config and UWSM env
  - `dms.nix` — DankMaterialShell config
  - `theme.nix` — GTK, cursor, Hyprcursor, and Plasma theme settings
- `home-configurations/mohi/` — shared user identity/home settings
- `modules/` — shared system modules
- `darwin-modules/` — Darwin system modules
- `assets/` — repo-managed images/assets

## Desktop notes

- DMS Greeter (`pkgs.dms-greeter`) is the display manager on `sauron`. The desktop shell comes from the `dms` flake input.
- The greeter compositor uses the same monitor layout as the desktop, but 8-bit color.
- The Hyprland portal is disabled for the `dms-greeter` account, not for desktop users.
- Plasma and Hyprland are intended to coexist; Hyprland is the primary tiling session.
- UWSM manages Hyprland's environment and lifecycle. DankMaterialShell starts only in that session and supplies its polkit agent; KDE wallet PAM setup is retained.
- Greeter and desktop share monitor definitions from `dotfiles.host.monitors`.
- `Super + Shift + M` toggles the secondary monitor off/on at runtime. Disabling it removes it from Hyprland's layout so the display can be used by another computer; re-enabling restores its configured mode and placement.

## Notes

- Zed is Nix-managed on NixOS and app-managed on Darwin.
- Language LSPs (rust-analyzer, gopls, clangd, zls) live in devenv shells, not the shared package set.
- LLM keys: `~/.config/llm.conf`, not in the Nix store. Use one `KEY=value` per line, with optional matching quotes around the value and full-line `#` comments. Fish loads values literally; use simple values or single quotes for portability, without shell substitutions, inline comments, or `export` prefixes. Bash/zsh startup snippets are provided but their Home Manager modules are currently disabled; shells started from Fish inherit its exported keys.
- 1Password SSH uses the app-group socket on macOS and `~/.1password/agent.sock` on Linux. Incoming SSH sessions retain their forwarded agent. Git uses 1Password's signing helper to sign commits.
