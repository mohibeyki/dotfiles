#!/usr/bin/env python3
"""Bulk-add gamescope launch options to all Steam games.

Requires: python3Packages.vdf
Run with: nix-shell -p python3Packages.vdf --run 'python3 scripts/steam-gamescope-all.py'

Backs up localconfig.vdf before modifying. Idempotent: safe to re-run.

Edit WIDTH and HEIGHT at the top of this script to change the gamescope resolution.
Defaults: 3840x2160.
"""
import shutil
import sys
from pathlib import Path

try:
    import vdf
except ImportError:
    print("Error: python vdf module not installed.")
    print("Run: nix-shell -p python3Packages.vdf --run 'python3 scripts/steam-gamescope-all.py'")
    sys.exit(1)

# --- Configurable resolution ---
# Change these values if you want a different gamescope resolution
WIDTH = 3840
HEIGHT = 2160
# -------------------------------

STEAM_ROOT = Path.home() / ".local/share/Steam"
USERDATA = STEAM_ROOT / "userdata"
LAUNCH_PREFIX = f"gamescope -W {WIDTH} -H {HEIGHT} -- "


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
            if LAUNCH_PREFIX.strip() in existing:
                skipped += 1
                continue

            if existing:
                appcfg["LaunchOptions"] = LAUNCH_PREFIX + existing
            else:
                appcfg["LaunchOptions"] = LAUNCH_PREFIX + "%command%"
            updated += 1

        with open(config_path, "w") as f:
            vdf.dump(data, f, pretty=True)

        print(
            f"Account {user_dir.name}: updated {updated} games, skipped {skipped} "
            f"(already had gamescope)"
        )

    print(
        f"\nDone. Set gamescope to {WIDTH}x{HEIGHT} for all games."
    )
    print("Restart Steam for changes to take effect.")
    print("To revert, copy the .backup file over localconfig.vdf.")


if __name__ == "__main__":
    main()
