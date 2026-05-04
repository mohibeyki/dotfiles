#!/usr/bin/env python3
"""Bulk-add gamescope launch options to all Steam games.

Requires: python3Packages.vdf
Run with: nix-shell -p python3Packages.vdf --run 'python3 scripts/steam-gamescope-all.py'

Backs up localconfig.vdf before modifying. Idempotent: re-running with different
settings strips any prior `gamescope ... --` wrapper before injecting the new one.

Edit WIDTH / HEIGHT / REFRESH / EXTRA_FLAGS at the top of this script to change
the gamescope invocation. Defaults: 3840x2160 @ 240Hz with VRR + native Wayland.
"""
import re
import shutil
import sys
from pathlib import Path

try:
    import vdf
except ImportError:
    print("Error: python vdf module not installed.")
    print("Run: nix-shell -p python3Packages.vdf --run 'python3 scripts/steam-gamescope-all.py'")
    sys.exit(1)

# --- Configurable gamescope invocation ---
WIDTH = 3840
HEIGHT = 2160
REFRESH = 240
EXTRA_FLAGS = ["--adaptive-sync", "--expose-wayland", "--backend", "wayland", "--rt"]
# -----------------------------------------

STEAM_ROOT = Path.home() / ".local/share/Steam"
USERDATA = STEAM_ROOT / "userdata"

GAMESCOPE_ARGS = ["gamescope", "-W", str(WIDTH), "-H", str(HEIGHT), "-r", str(REFRESH)] + EXTRA_FLAGS
LAUNCH_PREFIX = " ".join(GAMESCOPE_ARGS) + " -- "

# Matches any prior `gamescope ... --` wrapper at the start of the launch options,
# including the trailing separator and any whitespace after it. Non-greedy so it
# stops at the first ` -- ` (gamescope's argv separator).
GAMESCOPE_WRAPPER_RE = re.compile(r"^\s*gamescope\b.*?\s--\s+")


def strip_existing_gamescope(launch_options: str) -> str:
    """Remove any leading `gamescope ... --` wrapper from launch options."""
    # Loop in case the file accumulated multiple stacked wrappers from buggy runs.
    prev = None
    current = launch_options
    while prev != current:
        prev = current
        current = GAMESCOPE_WRAPPER_RE.sub("", current, count=1)
    return current


def build_launch_options(existing: str) -> str:
    """Return new LaunchOptions string with our gamescope wrapper applied."""
    inner = strip_existing_gamescope(existing).strip()
    if not inner:
        inner = "%command%"
    elif "%command%" not in inner:
        # Steam silently fails to launch if %command% is missing. Append it so
        # any user-set env vars (e.g. PROTON_LOG=1) still apply.
        inner = f"{inner} %command%"
    return LAUNCH_PREFIX + inner


def main():
    if not USERDATA.exists():
        print(f"Steam userdata not found at {USERDATA}")
        sys.exit(1)

    for user_dir in sorted(USERDATA.iterdir()):
        if not user_dir.is_dir() or not user_dir.name.isdigit():
            continue

        config_path = user_dir / "config" / "localconfig.vdf"
        if not config_path.exists():
            continue

        # Backup once (don't overwrite existing backup)
        backup_path = config_path.with_suffix(".vdf.backup")
        if not backup_path.exists():
            shutil.copy2(config_path, backup_path)
            print(f"Backed up to {backup_path}")

        with open(config_path, "r") as f:
            data = vdf.load(f)

        apps = (
            data.get("UserLocalConfigStore", {})
            .get("Software", {})
            .get("Valve", {})
            .get("Steam", {})
            .get("apps", {})
        )

        updated = 0
        skipped = 0
        for appid, appcfg in apps.items():
            if not isinstance(appcfg, dict):
                continue

            existing = appcfg.get("LaunchOptions", "")
            new_options = build_launch_options(existing)
            if new_options == existing:
                skipped += 1
                continue

            appcfg["LaunchOptions"] = new_options
            updated += 1

        with open(config_path, "w") as f:
            vdf.dump(data, f, pretty=True)

        print(
            f"Account {user_dir.name}: updated {updated} games, skipped {skipped} "
            f"(already up-to-date)"
        )

    print(f"\nDone. Applied: {LAUNCH_PREFIX.strip()}")
    print("Restart Steam for changes to take effect.")
    print("To revert, copy the .backup file over localconfig.vdf.")


if __name__ == "__main__":
    main()
