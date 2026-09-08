#!/usr/bin/env python3
"""Bulk-add gamescope launch options to all Steam games.

Requires: python3Packages.vdf
Run with: nix-shell -p python3Packages.vdf --run 'python3 scripts/steam-gamescope-all.py'

Backs up localconfig.vdf before modifying. Idempotent: re-running with different
settings strips any prior `gamescope ... --` wrapper before injecting the new one.

Edit WIDTH / HEIGHT / REFRESH at the top of this script
to change the launch wrapper.
"""
import re
import shutil
import sys
import argparse
from pathlib import Path

try:
    import vdf
except ImportError:
    print("Error: python vdf module not installed.")
    print("Run: nix-shell -p python3Packages.vdf --run 'python3 scripts/steam-gamescope-all.py'")
    sys.exit(1)

# --- Configurable launch wrapper ---
WIDTH = 3840
HEIGHT = 2160
REFRESH = 240
# -----------------------------------------

STEAM_ROOT = Path.home() / ".local/share/Steam"
USERDATA = STEAM_ROOT / "userdata"

GAMESCOPE_ARGS = [
    "gamescope",
    "-W",
    str(WIDTH),
    "-H",
    str(HEIGHT),
    "-w",
    str(WIDTH),
    "-h",
    str(HEIGHT),
    "-r",
    str(REFRESH),
]
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
    """Prefix gamescope while keeping any non-gamescope launch options."""
    remainder = strip_existing_gamescope(existing).strip()
    if not remainder:
        return LAUNCH_PREFIX + "%command%"
    if "%command%" in remainder:
        return LAUNCH_PREFIX + remainder
    return LAUNCH_PREFIX + remainder + " %command%"


def parse_args():
    parser = argparse.ArgumentParser(description="Bulk-update Steam LaunchOptions for all games.")
    parser.add_argument(
        "--clear-all",
        "--strip-all",
        dest="clear_all",
        action="store_true",
        help="Clear LaunchOptions from all Steam app entries instead of applying gamescope.",
    )
    parser.add_argument(
        "--self-test",
        action="store_true",
        help="Run launch-option preservation checks and exit.",
    )
    return parser.parse_args()


def _self_test() -> None:
    prefix = LAUNCH_PREFIX
    assert build_launch_options("") == prefix + "%command%"
    assert build_launch_options("%command%") == prefix + "%command%"
    assert (
        build_launch_options("PROTON_ENABLE_NVAPI=1 %command%")
        == prefix + "PROTON_ENABLE_NVAPI=1 %command%"
    )
    stacked = prefix + "PROTON_ENABLE_NVAPI=1 %command%"
    assert build_launch_options(stacked) == stacked
    assert (
        build_launch_options("PROTON_ENABLE_NVAPI=1")
        == prefix + "PROTON_ENABLE_NVAPI=1 %command%"
    )
    print("self-test ok")


def main():
    args = parse_args()

    if args.self_test:
        _self_test()
        return

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
            if args.clear_all:
                new_options = ""
            else:
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

    if args.clear_all:
        print("\nDone. Cleared LaunchOptions for all Steam app entries.")
    else:
        print(f"\nDone. Applied: {LAUNCH_PREFIX.strip()}")
    print("Restart Steam for changes to take effect.")
    print("To revert, copy the .backup file over localconfig.vdf.")


if __name__ == "__main__":
    main()
