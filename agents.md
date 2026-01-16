# Agents

This project uses AI agents to assist with development and maintenance. Below are the guidelines and context for these agents.

## Project Structure
- `nix/`: Core Nix configuration files.
  - `hosts/`: Host-specific configurations for NixOS and macOS (Darwin).
  - `home/`: Home Manager configuration and modules (Hyprland, Fish, etc.).
  - `modules/`: Shared Nix modules.
  - `programs/`: Specific program configurations.

## Development Workflow
- **Nix Flakes**: This repository uses Nix Flakes for dependency management.
- **Home Manager**: Used for managing user-specific configurations.
- **Linting/Formatting**: Use `nixfmt` for Nix files where available.

## Agent Instructions
- Always read existing module patterns before creating new ones.
- Follow the established naming conventions for hosts and modules.
- Ensure any changes to `flake.nix` or `flake.lock` are verified.
- When adding new programs, consider if they should be a shared module in `nix/modules/` or a home-manager module in `nix/home/modules/`.
