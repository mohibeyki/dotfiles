# Dotfiles

Nix flake-based configuration for NixOS and macOS. Uses [home-manager](https://nix-community.github.io/home-manager/) for user packages and dotfiles.

## Installation

### NixOS

```bash
git clone https://github.com/yourusername/dotfiles.git ~/dotfiles
cd ~/dotfiles
sudo nixos-rebuild switch --flake .#sauron
```

### macOS

```bash
git clone https://github.com/yourusername/dotfiles.git ~/dotfiles
cd ~/dotfiles
nix run nix-darwin -- switch --flake .#legolas
```

## Project Structure

```
.
├── flake.nix              # Entry point
├── flake/                 # Flake modules
│   ├── core.nix          # Supported systems
│   ├── hosts.nix         # Host discovery
│   └── per-system.nix    # Dev shells and checks
├── lib/                   # Library functions
│   ├── flakeHosts.nix    # Host discovery
│   └── mkHosts.nix       # Host builders
├── hosts/                 # Host configurations
│   ├── sauron/           # NixOS desktop
│   └── legolas/          # macOS laptop
├── modules/               # NixOS/Darwin modules
│   ├── common.nix        # Shared configuration
│   ├── nixos.nix         # NixOS base
│   ├── gnome.nix         # GNOME desktop
│   ├── hyprland.nix      # Hyprland compositor
│   ├── plasma.nix        # KDE Plasma (unused)
│   └── ...
└── home/                  # Home-manager modules
    ├── default.nix       # Base home config
    └── modules/          # Individual modules
```

## Hosts

- **sauron**: NixOS desktop with NVIDIA GPU
  - GNOME + GDM (Wayland)
  - Hyprland (alternative WM)
  - Gaming (Steam, NVIDIA drivers)

- **legolas**: macOS laptop (M-series)
  - TouchID for sudo

## Modules

### System Modules

- `common.nix`: Shared Nix/nixpkgs settings, fonts, basic packages
- `nixos.nix`: NixOS-specific base configuration
- `gnome.nix`: GNOME desktop environment
- `hyprland.nix`: Hyprland window manager with UWSM
- `nvidia.nix`: NVIDIA driver configuration
- `dev.nix`: Development tools (clang, rust, go, LSPs, LLM agents)
- `steam.nix`: Gaming support
- `plasma.nix`: KDE Plasma (available but unused)

### Home Modules

- `hyprland.nix`: Hyprland keybinds and window rules
- `noctalia.nix`: Noctalia Shell with plugins
- `theme.nix`: GTK/cursor theming
- `helix.nix`, `ghostty.nix`, `tmux.nix`, `zellij.nix`: Editor/terminal configs

## Secrets

Uses [agenix](https://github.com/ryantm/agenix) for encrypted secrets. Place secrets in `secrets/` directory.

```bash
# Edit secrets
agenix -e secrets/example.age
```

## Development

```bash
# Enter dev shell
nix develop

# Run checks
nix flake check
```

## License

MIT
