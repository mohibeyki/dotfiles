# Deferred NixOS review — 2026-09-12

Reviewed `nixos-modules/`, `nixos-configurations/`, `home-modules/nixos/`, the host option definitions, `.luarc.json`, the Linux 1Password service, and `scripts/steam-gamescope-all.py`. Implementation changes are deferred until Sauron is reinstalled, as requested. The main review's `nix flake check` successfully evaluated Sauron; this does not establish that Linux packages build or that the graphical session works on its hardware.

## Confirmed defects to fix

### P1 — Steam bulk wrapper can make existing game launch options unlaunchable

Location: `scripts/steam-gamescope-all.py:67-74`, with incorrect expectations in its self-test at lines 98–106.

The wrapper puts everything after `gamescope ... --`, but that position requires an executable followed by its arguments. Two outputs were reproduced by running the actual transformation functions, without accessing Steam data:

| Existing options | Current output | Problem |
|---|---|---|
| `-novid` | `gamescope ... -- -novid %command%` | The game argument becomes the executable. |
| `PROTON_ENABLE_NVAPI=1 %command%` | `gamescope ... -- PROTON_ENABLE_NVAPI=1 %command%` | The environment assignment becomes the executable, rather than a shell assignment. |

Fix: preserve Steam's argument-only semantics as `gamescope ... -- %command% -novid`. For environment assignments, use an explicit `env`, such as `gamescope ... -- env PROTON_ENABLE_NVAPI=1 %command%`, or keep assignments before the wrapper. Treat shell operators, quoted commands, and custom wrappers explicitly; skip/report forms that cannot be transformed reliably. Replace the current self-test expectations with executable-semantics checks and retain idempotence coverage. Do not run the bulk update against real games until these cases pass.

Validation after reinstall: use a temporary VDF fixture with empty options, plain game arguments, environment assignments, an existing wrapper, and quoted arguments; confirm the launched test executable receives the intended arguments and environment. Then try one actual game before applying across accounts.

### P2 — Secondary monitor toggle trusts a stale marker instead of the monitor

Location: `home-modules/nixos/hyprland.nix:108-119`; configuration application is in `home-modules/nixos/hypr/host.lua:3-5`.

The toggle reads only `$XDG_RUNTIME_DIR/hypr-secondary-monitor.disabled`. Reloading the configuration reapplies the configured monitors, but nothing reconciles that marker. After disabling the secondary display and reloading, the next toggle takes the enable branch even though the display is enabled already. The marker is also shared across compositor instances in the same user runtime directory.

Fix: determine whether the configured display is enabled from the current compositor's monitor query, instead of treating a separate file as authoritative. Match its configured description safely. If retaining a marker, scope it to the compositor instance and reconcile it when applying host configuration.

Validation after reinstall: toggle twice, disable then reload then toggle, and repeat after logging out/in with another user session still running. Check actual enabled displays with `hyprctl monitors all -j` after each step. The pinned Hyprland source confirms that a successful `hyprctl eval` returns `ok`, so the existing response-prefix check is not itself a defect.

## Reinstall prerequisites and runtime checks

These are pending setup or checks, not additional verified bugs.

- **Regenerate hardware configuration before installing.** `nixos-configurations/sauron/hardware.nix:27-50` explicitly retains the previous root/EFI UUIDs. Its planned `@nix`, `@home`, and `@log` subvolumes have no mount entries yet. Generate configuration against the mounted replacement installation, reconcile its UUIDs/subvolume mounts with this host, and inspect `findmnt / /nix /home /var/log /boot` after boot. Do not reuse old identifiers blindly.
- **Provision login access.** The user is declared in `nixos-modules/base.nix:93`, without a declarative password or authorized SSH key. SSH password authentication is disabled at line 71. Establish the local user's password and intended authorized keys through the installation workflow before relying on graphical or remote login; do not put private keys or plaintext passwords into the flake.
- **Validate NVIDIA suspend with the actual disk and driver.** `nixos-modules/nvidia.nix:17-20` disables power management based on an old VRAM/swap explanation. The pinned nixpkgs module has a kernel-suspend-notifier path for sufficiently new open NVIDIA drivers. Revisit the comment and selected strategy against the installed driver; avoid enabling preservation solely because a large swap partition exists. Check suspend/resume with real workloads and inspect the journal before making this a permanent change.
- **Test the two graphical sessions separately.** Check the DMS greeter, then Hyprland/UWSM startup and logout, then Plasma. Confirm `systemctl --user --failed`, DMS, portals, KWallet unlock, screen sharing, and file selection. The Linux 1Password service is wanted by `dms.service`, so its automatic launch applies to the DMS session; check whether manual launch or Plasma autostart is desired in Plasma. `After=dms.service` only orders service startup and does not prove the StatusNotifier watcher is ready, so check the 1Password tray on repeated logins.
- **Run the Steam helper only with Steam fully exited.** It currently rewrites `localconfig.vdf` in place (`scripts/steam-gamescope-all.py:166`) and keeps only the first backup (`:130`). A later run can only restore that older snapshot, and a failed write can truncate the current file. Before future use, prefer a per-run backup and atomic replacement of a successfully serialized file; verify the client is not concurrently managing it. The script's current instruction to restart Steam afterward does not enforce that prerequisite.

## Validation sequence on Sauron

After reconciling the hardware configuration and the deferred fixes:

```bash
nix flake check
nix build .#nixosConfigurations.sauron.config.system.build.toplevel --dry-run --no-link
nix build .#nixosConfigurations.sauron.config.system.build.toplevel --no-link
```

Apply with the documented NixOS rebuild workflow when ready, then perform the runtime checks above. No system rebuild, Steam-data write, or NixOS implementation edit was performed during this review.
