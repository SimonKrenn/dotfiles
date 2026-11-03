#!/usr/bin/env python3
"""Static migration checks, plus an opt-in read-only live ownership preflight."""
import argparse
import json
from pathlib import Path
import subprocess
import sys
import tomllib

ROOT = Path(__file__).resolve().parents[1]


def owned_symlinks(target, home):
  """Include ancestors: a regular-looking file can live under a Nix symlink."""
  # Preserve lexical paths so broken links remain visible; stop at home.
  target.relative_to(home)
  links = []
  path = target
  while path != home:
    if path.is_symlink():
      links.append(path)
    path = path.parent
  return links


def validate(inventory=None, preflight=False):
  config = tomllib.loads((ROOT / 'mise.toml').read_text())
  runtime = tomllib.loads((ROOT / 'migration/mise/config.toml').read_text())
  assert config['tools'] == runtime['tools'], 'Root/global runtime inventory drift'
  assert config['bootstrap']['user']['login_shell'] == '/opt/homebrew/bin/fish'
  assert 'mise_shell_activate' not in config['bootstrap'], 'Fish owns activation'
  lock = tomllib.loads((ROOT / 'mise.lock').read_text())
  assert set(lock['tools']) == set(config['tools']), 'Runtime lock inventory drift'
  for tool, versions in lock['tools'].items():
    assert config['tools'][tool] in versions[0]['specifiers'], tool
    for version in versions:
      if 'aube' in version:
        metadata = ROOT / version['aube']['path']
        assert (metadata / 'package.json').is_file(), f'Missing dependency manifest: {tool}'
        assert (metadata / 'aube-lock.yaml').is_file(), f'Missing dependency lock: {tool}'
  packages = config['bootstrap']['packages']
  for duplicate in ('mise', 'opencode', 'rust', 'cargo', 'node', 'bun', 'stow'):
    assert 'brew:' + duplicate not in packages, duplicate
  known = set(json.loads(Path(inventory).read_text())) if inventory else None
  errors = []
  home = Path.home()
  for target, entry in config['dotfiles'].items():
    assert target.startswith('~/'), target
    assert entry['mode'] == 'copy', 'Trial should not link mutable files into its checkout'
    source = entry['source']
    if source.startswith('~/'):
      assert any(source.startswith(repo + '/') for repo in config['bootstrap']['repos']), source
    elif not (ROOT / source).exists() and (known is None or source not in known):
      errors.append('Missing source: ' + source)
    if preflight:
      path = home / target[2:]
      for link in owned_symlinks(path, home):
        errors.append(f'Existing owner: {link} -> {link.readlink()}')
      if path.is_dir() and not path.is_symlink():
        for child in path.rglob('*'):
          if child.is_symlink():
            errors.append(f'Existing nested link: {child}')
  if preflight:
    for legacy in ('.tmux.conf', '.gitconfig'):
      path = home / legacy
      if path.exists() or path.is_symlink():
        errors.append(f'Review legacy precedence before apply: {path}')
  for path in (ROOT / 'migration').rglob('*'):
    if path.suffix in ('.fish', '.conf') and path.is_file():
      content = path.read_text()
      assert '/Users/' not in content and '/etc/profiles/' not in content, path
  assert 'mise activate fish | source' in (ROOT / 'migration/fish/config.fish').read_text()
  if errors:
    raise ValueError('\n'.join(sorted(set(errors))))
  print(f'PASS: {len(config["dotfiles"])} dotfile targets, {len(packages)} host packages, runtime parity')


if __name__ == '__main__':
  parser = argparse.ArgumentParser()
  parser.add_argument('--inventory', help='Offline source inventory JSON for connector-only testing')
  parser.add_argument('--preflight', action='store_true')
  args = parser.parse_args()
  try:
    validate(args.inventory, args.preflight)
    for script in (ROOT / 'migration').glob('*.sh'):
      subprocess.run(['bash', '-n', str(script)], check=True)
    subprocess.run(['git', 'config', '--file', str(ROOT / 'migration/git/config'), '--list'],
                   check=True, stdout=subprocess.DEVNULL)
  except (AssertionError, ValueError, subprocess.CalledProcessError) as error:
    print(error, file=sys.stderr)
    sys.exit(1)
