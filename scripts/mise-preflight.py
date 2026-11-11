#!/usr/bin/env python3
"""Block active Nix ownership while allowing verified leftovers after handoff."""
import sys
from pathlib import Path
sys.dont_write_bytecode = True
from mise_state import active_home_files, classify_nix_links, nix_links

blocked, stale = classify_nix_links(nix_links(), Path.home(), active_home_files())
if blocked:
  print("Nix-owned deployment targets remain (or ownership cannot be verified):", file=sys.stderr)
  for path in blocked:
    print(f"  {path}", file=sys.stderr)
  print("Run the backup task, then activate the matching *-mise Nix handoff "
        "generation described in README.md before applying mise.", file=sys.stderr)
  sys.exit(1)
if stale:
  print(f"Preflight passed: {len(stale)} leftover Home Manager links are absent "
        "from the active generation and can be replaced after backup.")
else:
  print("Preflight passed: no deployment targets point into the Nix store.")
