"""Deployment paths shared by the migration preflight and backup."""
from pathlib import Path
import fnmatch
import tomllib

ROOT = Path(__file__).resolve().parents[1]


def entries():
  return tomllib.loads((ROOT / "mise.toml").read_text())["dotfiles"].items()


def excluded(relative, patterns):
  path = Path(relative)
  for pattern in patterns:
    if "/" in pattern:
      if fnmatch.fnmatch(relative, pattern) or relative.startswith(pattern + "/"):
        return True
    elif any(fnmatch.fnmatch(part, pattern) for part in path.parts):
      return True
  return False


def deployment_paths():
  for target, spec in entries():
    destination = Path(target).expanduser()
    if spec["mode"] != "symlink-each":
      yield destination
      continue
    # The directory itself can be a Home Manager link into an immutable store.
    yield destination
    source = ROOT / spec["source"]
    for path in source.rglob("*"):
      relative = path.relative_to(source)
      if excluded(str(relative), spec.get("exclude", [])):
        continue
      if path.is_file() or path.is_symlink():
        yield destination / relative


def nix_links():
  found = set()
  for path in deployment_paths():
    for candidate in (path, *path.parents):
      if candidate.is_symlink() and str(candidate.resolve()).startswith("/nix/store/"):
        found.add(str(candidate))
  return sorted(found)


def active_home_files():
  """Return the manifest of the currently activated Home Manager generation."""
  current = Path.home() / ".local/state/home-manager/gcroots/current-home"
  if not current.is_symlink():
    return None
  generation = current.resolve()
  if not str(generation).startswith("/nix/store/") or not generation.name.endswith("-home-manager-generation"):
    return None
  files = generation / "home-files"
  return files if files.is_dir() else None


def classify_nix_links(links, home, active_files):
  """Only allow old Home Manager links absent from the active manifest."""
  blocked, stale = [], []
  for name in links:
    path = Path(name)
    old_target = str(path.readlink())
    home_manager_link = (
      "-home-manager-generation/" in old_target
      or "-home-manager-files/" in old_target
    )
    if active_files is None or not home_manager_link:
      blocked.append(name)
      continue
    try:
      declared = active_files / path.relative_to(home)
    except ValueError:
      blocked.append(name)
      continue
    # A dangling declaration is still managed; never replace it automatically.
    if declared.exists() or declared.is_symlink():
      blocked.append(name)
    else:
      stale.append(name)
  return blocked, stale
