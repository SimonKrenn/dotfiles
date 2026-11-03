#!/usr/bin/env python3
"""Read-only availability check for all declared Homebrew package definitions."""
from concurrent.futures import ThreadPoolExecutor
import json
from pathlib import Path
import sys
import tomllib
import urllib.request

ROOT = Path(__file__).resolve().parents[1]


def check(package):
  backend, name = package.split(':', 1)
  kind = 'formula' if backend == 'brew' else 'cask'
  parts = name.split('/')
  if len(parts) == 1:
    urls = [f'https://formulae.brew.sh/api/{kind}/{name}.json']
  else:
    owner, tap, token = parts
    folder = 'Formula' if kind == 'formula' else 'Casks'
    urls = [f'https://raw.githubusercontent.com/{owner}/homebrew-{tap}/HEAD/{folder}/{token}.rb',
            f'https://raw.githubusercontent.com/{owner}/homebrew-{tap}/HEAD/{folder}/{token[0]}/{token}.rb']
  errors = []
  for url in urls:
    try:
      request = urllib.request.Request(url, headers={'User-Agent': 'dotfiles-package-check'})
      with urllib.request.urlopen(request, timeout=45) as response:
        body = response.read()
      if url.endswith('.json'):
        metadata = json.loads(body)
        assert not metadata.get('disabled'), 'package is disabled'
        version = metadata.get('versions', {}).get('stable') or metadata.get('version')
      else:
        assert b'url ' in body, 'tap definition has no download URL'
        version = 'tap definition found'
      return True, f'PASS {package}: {version}'
    except Exception as error:
      errors.append(str(error))
  return False, f'FAIL {package}: {"; ".join(errors)}'


if __name__ == '__main__':
  packages = tomllib.loads((ROOT / 'mise.toml').read_text())['bootstrap']['packages']
  with ThreadPoolExecutor(max_workers=6) as executor:
    results = list(executor.map(check, packages))
  for _, message in results:
    print(message)
  print(f'{sum(ok for ok, _ in results)}/{len(results)} package definitions available')
  sys.exit(0 if all(ok for ok, _ in results) else 1)
