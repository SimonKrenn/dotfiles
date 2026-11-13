#!/usr/bin/env python3
"""Snapshot links and dereferenced configs before changing deployment ownership."""
from datetime import datetime, timezone
import json
import os
from pathlib import Path
import shutil
import subprocess
import sys
sys.dont_write_bytecode = True
from mise_state import entries

os.umask(0o077)
base = Path(os.environ.get("XDG_STATE_HOME", str(Path.home() / ".local/state")))
backup = base / "dotfiles/backups" / datetime.now(timezone.utc).strftime("%Y%m%dT%H%M%S.%fZ")
backup.mkdir(parents=True, mode=0o700)
manifest = []
# Preserve local files too, but omit generated dependency trees and repository metadata.
ignore = shutil.ignore_patterns("node_modules", ".git", "__pycache__")


def stored(path):
  """Include dangling symlinks when checking an existing snapshot path."""
  return path.exists() or path.is_symlink()


for target, _ in entries():
  source = Path(target).expanduser()
  if not stored(source):
    manifest.append({"path": str(source), "kind": "missing"})
    continue
  relative = source.relative_to(Path.home())
  record = {"path": str(source), "kind": "symlink" if source.is_symlink() else "file"}
  saved = backup / "original" / relative
  saved.parent.mkdir(parents=True, exist_ok=True)
  # A nested target may already have been captured by its parent directory.
  # Its manifest record is still needed, but its backup paths must not be rewritten.
  if not stored(saved):
    if source.is_symlink():
      saved.symlink_to(source.readlink())
    elif source.is_dir():
      shutil.copytree(source, saved, symlinks=True, ignore=ignore)
    else:
      shutil.copy2(source, saved)
  if source.is_symlink():
    record["link"] = str(source.readlink())
  elif source.is_dir():
    record["kind"] = "directory"
  # Keep readable contents independently of the Nix store and symlink lifetime.
  readable = backup / "contents" / relative
  readable.parent.mkdir(parents=True, exist_ok=True)
  if not stored(readable):
    if source.is_dir():
      shutil.copytree(source, readable, symlinks=False, ignore=ignore, ignore_dangling_symlinks=True)
    elif source.exists():
      shutil.copy2(source, readable, follow_symlinks=True)
  manifest.append(record)
(backup / "manifest.json").write_text(json.dumps(manifest, indent=2) + "\n")
# Version inventories never include credentials or configuration values.
for name, command in {
  "brew-formulae.txt": ["/opt/homebrew/bin/brew", "list", "--formula", "--versions"],
  "brew-casks.txt": ["/opt/homebrew/bin/brew", "list", "--cask", "--versions"],
  "mise-tools.json": ["/opt/homebrew/bin/mise", "ls", "--json"],
}.items():
  result = subprocess.run(command, capture_output=True, text=True)
  (backup / name).write_text(result.stdout)
  if result.returncode:
    (backup / (name + ".error")).write_text(result.stderr)
print(f"Backup saved to {backup}")
