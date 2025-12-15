# AGENTS.md

## Repository Overview

This is a **Nix flake-based dotfiles repository** for managing system configuration and user environment using:
- **Nix flakes** with nixpkgs-unstable
- **nix-darwin** for macOS system configuration
- **home-manager** for user-level dotfiles and packages
- Minimal neovim configuration in `config/nvim/`

**User**: mohi (Mohi Beyki, mohibeyki@gmail.com)
**Primary machines**: `legolas` and `arwen` (both aarch64-darwin/Apple Silicon Macs)

## Essential Commands

### System Management

**Apply configuration changes** (most common):
```bash
# From repository root
darwin-rebuild switch --flake .#legolas
# or
darwin-rebuild switch --flake .#arwen
```

**Build without switching** (for testing):
```bash
darwin-rebuild build --flake .#legolas
```

**Update flake inputs** (nixpkgs, home-manager, etc.):
```bash
nix flake update
```

**Update specific input**:
```bash
nix flake update nixpkgs
nix flake update home-manager
```

**Show flake info**:
```bash
nix flake show
nix flake metadata
```

**Check configuration** (lint):
```bash
statix check nix/  # Nix linter
nixfmt-rfc-style nix/**/*.nix  # Format Nix files
```

**List generations**:
```bash
darwin-rebuild --list-generations
```

**Rollback**:
```bash
darwin-rebuild --rollback
```

### Development

**Enter development shell** (if flake provides devShell):
```bash
nix develop
```

**Run one-off commands**:
```bash
nix run nixpkgs#package-name
```

**Search for packages**:
```bash
nix search nixpkgs package-name
```

## Repository Structure

```
dotfiles/
├── nix/
│   ├── flake.nix          # Main flake definition, lists machines
│   ├── flake.lock         # Lock file for reproducible builds
│   ├── helper.nix         # Helper functions: mkDarwin, mkNixos, mkMerge
│   ├── modules/
│   │   ├── common.nix     # Shared config (nix settings, fonts, shells)
│   │   ├── darwin.nix     # macOS-specific config
│   │   └── dev.nix        # Development packages and tools
│   ├── home/
│   │   ├── default.nix    # Home-manager entry point
│   │   ├── fish.nix       # Fish shell config
│   │   ├── ghostty.nix    # Ghostty terminal config
│   │   ├── helix.nix      # Helix editor config
│   │   └── tmux.nix       # Tmux config
│   ├── hosts/
│   │   └── darwin/
│   │       ├── legolas/   # Machine-specific config
│   │       └── arwen/     # Machine-specific config
│   ├── programs/
│   │   ├── ghostty.nix    # System-level Ghostty package
│   │   └── steam.nix
│   └── overlays/
├── config/
│   └── nvim/              # Neovim config (LazyVim-based)
└── README.md
```

## Code Organization

### Flake Structure

**`flake.nix`**: 
- Defines inputs (nixpkgs, nix-darwin, home-manager, neovim-nightly-overlay, fenix)
- Uses helper functions from `helper.nix`
- Calls `mkDarwin` for each macOS machine with module lists

**`helper.nix`**:
- Exports: `mkDarwin`, `mkNixos`, `mkMerge`
- `mkDarwin`: Creates darwinConfiguration with system packages, home-manager integration, and host-specific modules
- `mkNixos`: Similar but for NixOS (currently unused)
- `homeManagerCfg`: Sets up home-manager with user "mohi" and imports from `./home`

### Module System

**System modules** (`nix/modules/`):
- `common.nix`: Nix settings (experimental features, flakes), fonts (JetBrains Mono Nerd Font), basic packages
- `darwin.nix`: macOS-specific settings (Touch ID sudo, system state version)
- `dev.nix`: Development tooling (go, zig, rust via fenix, clang, helix, neovim-nightly, LSPs, formatters)

**Home-manager modules** (`nix/home/`):
- `default.nix`: Imports other home modules, sets up git, neovim, direnv
- Program-specific configs: fish, ghostty, helix, tmux

**Host configs** (`nix/hosts/darwin/{legolas,arwen}/`):
- Each contains `default.nix` with machine-specific settings (mostly minimal)
- Sets system.stateVersion, hostPlatform, Touch ID sudo

## Naming Conventions

### File Naming
- All Nix files use `.nix` extension
- Module names match their purpose: `dev.nix`, `fish.nix`, `helix.nix`
- Host directories named after machine hostnames

### Nix Code Style
- **Indentation**: 2 spaces (standard Nix style)
- **Formatting**: Use `nixfmt-rfc-style` for consistent formatting
- **Attribute sets**: Use trailing semicolons
- **Lists**: One item per line for long lists, inline for short lists
- **Strings**: Use `''` (double single-quote) for multiline strings
- **Functions**: Pattern `{ pkgs, inputs, ... }:` for module arguments

### Variable Naming
- `pkgs` for nixpkgs package set
- `inputs` for flake inputs
- `machineHostname` for host identifiers
- Standard Nix naming: dash-separated for attributes (`home-manager`, `nix-darwin`)

## Development Tools & Packages

### Installed System-Wide (via `dev.nix`)

**Languages & Compilers**:
- Go: `go`, `gopls`, `gofumpt`, `gotools`
- Zig: `zig`, `zls`
- C/C++: `clang`, `clang-tools`, `gcc`, `lldb`
- Rust: Via fenix overlay (not explicitly listed in dev.nix currently)
- Node.js: `nodejs`
- Python: `python3`

**Editors & Tools**:
- Neovim: `neovim-nightly` (from overlay)
- Helix: `helix` + `tree-sitter`
- LSPs: `nixd`, `lua-language-server`, `gopls`, `zls`, `marksman`
- Formatters: `nixfmt-rfc-style`, `stylua`, `gofumpt`
- Linters: `statix`, `selene`, `markdownlint-cli2`

**CLI Utilities**:
- `fd`, `fzf`, `ripgrep`, `jq`, `git`, `lazygit`, `gnumake`, `tmux`, `zellij`, `btop`

**AI Tools**:
- `claude-code`, `crush`

### Editor Configurations

**Helix** (`nix/home/helix.nix`):
- Theme: `tokyonight_moon`
- Auto-format enabled for all configured languages
- Rulers at 160 columns, text width 160
- Language servers configured: rust-analyzer, clangd, zls
- Custom keybindings: Ctrl-[ (prev buffer), Ctrl-] (next buffer), Ctrl-q (close buffer)
- Languages configured: Rust (4 spaces), Zig (4 spaces), C/C++ (4 spaces), TOML (taplo formatter)

**Neovim** (`config/nvim/`):
- LazyVim-based configuration
- Managed through `config/nvim/lua/plugins/mohi.lua`
- Aliases: `vi`, `vim`, `vimdiff` all point to nvim
- Set as default $EDITOR

**Tmux** (`nix/home/tmux.nix`):
- Prefix: `Ctrl-a`
- Base index: 1
- Terminal: ghostty
- Theme: tokyo-night-tmux
- Plugins: sensible, vim-tmux-navigator, yank
- Custom bindings: `\` for horizontal split, `-` for vertical split, `M-h`/`M-l` for window navigation

**Fish Shell** (`nix/home/fish.nix`):
- Pure prompt (single-line mode enabled)
- Custom function: `d` (ssh to dev server via x2ssh)
- $EDITOR set to nvim

**Ghostty Terminal** (`nix/home/ghostty.nix`):
- Font: JetBrainsMono Nerd Font
- Theme: TokyoNight
- Ligatures disabled (`-calt`, `-liga`, `-dlig`)
- macOS: Option key as Alt, quit after last window closed

## Git Configuration

Configured in `nix/home/default.nix`:

```nix
user.name = "Mohi Beyki"
user.email = "mohibeyki@gmail.com"

aliases:
  co = checkout
  ci = commit
  st = status
  br = branch
  hist = log --pretty=format:'%h %ad | %s%d [%an]' --graph --date=short

init.defaultBranch = main
push.autoSetupRemote = true

ignores: [".DS_Store"]
```

## Important Gotchas

### Flake Purity
- **Files must be tracked by git** for nix flake commands to see them
- After creating new `.nix` files, `git add` them before running `darwin-rebuild`
- Changes to unstaged files won't be visible to the flake

### Home Manager
- Backup file extension set to `.bak`
- Home directory forced to `/Users/mohi` for macOS (see `helper.nix:34`)
- User packages mode: `useUserPackages = true` (packages installed per-user, not system-wide)
- State version: `25.11`

### Package Installation
- **System packages**: Add to `environment.systemPackages` in modules
- **User packages**: Install via home-manager in `nix/home/default.nix` (preferred for user tools)
- Packages from overlays: Use `inputs.<overlay>.packages.${pkgs.stdenv.hostPlatform.system}.<package>`

### Platform-Specific
- All configs currently target **aarch64-darwin** (Apple Silicon)
- NixOS configuration exists (`helper.nix:mkNixos`) but is not actively used
- Ghostty on macOS: Installed via DMG manually, home-manager only manages config (`package = null`)

### Rebuild Behavior
- `darwin-rebuild switch`: Builds and activates immediately, sets as boot default
- Changes to home-manager modules require full system rebuild
- Flake lock updates may cause large downloads (entire nixpkgs channel)

### Formatting & Linting
- **Nix formatter**: `nixfmt-rfc-style` (official RFC 166 style)
- **Nix linter**: `statix check`
- Run before committing changes to maintain consistency
- Helix auto-formats on save (various formatters per language)

### Binary Caches
Configured substituters (in `flake.nix`):
- https://cache.nixos.org
- https://nixpkgs.cachix.org
- https://nix-community.cachix.org

This speeds up builds by downloading pre-built packages.

## Testing Changes

### Local Testing Workflow

1. **Edit Nix files** in `nix/`
2. **Stage changes**: `git add nix/` (required for flakes!)
3. **Build without switching**: `darwin-rebuild build --flake .#legolas`
4. **Check for errors**: Fix any build failures
5. **Switch**: `darwin-rebuild switch --flake .#legolas`
6. **Verify**: Test the changed functionality
7. **Commit if successful**: `git commit -m "description"`

### Quick Iteration
```bash
# One-liner for quick testing (stages, builds, switches)
git add -A && darwin-rebuild switch --flake .#legolas
```

### Rollback if Issues
```bash
darwin-rebuild --rollback
```

## Common Modification Patterns

### Adding a System Package

Edit `nix/modules/dev.nix`:
```nix
environment.systemPackages = with pkgs; [
  # ... existing packages
  new-package-name
];
```

### Adding a Home-Manager Package

Edit `nix/home/default.nix`:
```nix
home.packages = with pkgs; [
  new-package-name
];
```

### Adding a New Machine

1. Create `nix/hosts/darwin/new-machine/default.nix`
2. Add to `nix/flake.nix`:
```nix
(mkDarwin "new-machine" inputs.nixpkgs
  [
    ./modules/dev.nix
  ]
  [ ]
)
```
3. Run: `darwin-rebuild switch --flake .#new-machine`

### Adding a New Home Module

1. Create `nix/home/new-program.nix`
2. Import in `nix/home/default.nix`:
```nix
imports = [
  # ... existing imports
  ./new-program.nix
];
```

### Updating a Package

**Update all inputs**:
```bash
nix flake update
darwin-rebuild switch --flake .#legolas
```

**Update specific input**:
```bash
nix flake lock --update-input neovim-nightly-overlay
darwin-rebuild switch --flake .#legolas
```

## Cache Substituters

The flake is configured with Cachix substituters to speed up builds:
- cache.nixos.org: Official NixOS binary cache
- nixpkgs.cachix.org: Nixpkgs cache
- nix-community.cachix.org: Community packages (includes neovim-nightly)

Trust is configured via public keys in `flake.nix:nixConfig`.

## Current Branch Context

**Current branch**: `home-manager`
**Recent change**: Started using home-manager, made config macOS-only

**Modified file**: `nix/modules/dev.nix`

This suggests active work on transitioning to or refining home-manager integration.

## Non-Obvious Patterns

### Home Manager Integration
- Home-manager is integrated as a **Darwin module**, not standalone
- Configuration happens in `helper.nix:homeManagerCfg`
- User is hardcoded to "mohi"
- Imports from `./home` directory automatically

### Overlay Usage
- Neovim uses `neovim-nightly-overlay` for latest nightly builds
- Fenix overlay for Rust toolchain (input declared but not actively used in dev.nix)
- Packages from overlays accessed via `inputs.<overlay>.packages.${pkgs.stdenv.hostPlatform.system}`

### Module Composition
- `mkDarwin` automatically includes: `darwin.nix`, `common.nix`, host-specific config, home-manager
- Extra modules passed as list: `extraModules`
- Extra home-manager modules: `extraHmModules`
- This allows flexible per-machine customization without duplicating base config

### Fish Function Pattern
Custom shell functions defined in Nix:
```nix
functions = {
  function-name = {
    body = ''
      # Fish shell code here
    '';
  };
};
```

### Ghostty Dual Configuration
- System-level package in `nix/programs/ghostty.nix` (for NixOS)
- Home-manager config in `nix/home/ghostty.nix` with `package = null` (for macOS)
- This handles cross-platform differences

## Security Considerations

- Touch ID authentication enabled for sudo on both machines
- Trusted users: root, mohi
- Public keys for binary caches are explicitly listed (prevents MITM)
- Allow unfree packages enabled (`nixpkgs.config.allowUnfree = true`)

## Documentation & Resources

- **Nix manual**: https://nixos.org/manual/nix/stable/
- **Nix Darwin manual**: https://daiderd.com/nix-darwin/manual/
- **Home Manager manual**: https://nix-community.github.io/home-manager/
- **Nixpkgs search**: https://search.nixos.org/packages
- **NixOS discourse**: https://discourse.nixos.org/

## Maintenance Notes

### Regular Tasks
- Update flake inputs monthly: `nix flake update`
- Check for deprecated options: `darwin-rebuild build` (warnings will show)
- Clean old generations: `nix-collect-garbage -d` (frees disk space)
- Review flake.lock changes before committing

### Debugging
- Show full build logs: `darwin-rebuild switch --show-trace --print-build-logs`
- Check derivation: `nix show-derivation`
- Evaluate attribute: `nix eval .#darwinConfigurations.legolas.config.system.stateVersion`

### Performance
- Binary caches significantly speed up builds
- Large downloads expected when updating nixpkgs
- First build on new machine takes longest (downloads base system)
- Subsequent builds are incremental

---

**Last Updated**: Based on commit `751fcaa` (started using home manager, made config mac only for now)
