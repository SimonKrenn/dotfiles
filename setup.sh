#!/bin/bash
set -euo pipefail
export PATH="/opt/homebrew/opt/ruby/bin:/opt/homebrew/bin:/opt/homebrew/sbin:$PATH"

repo_dir="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
cd "$repo_dir"

if [[ "$(uname -s)" != "Darwin" || "$(uname -m)" != "arm64" ]]; then
  echo "This bootstrap currently targets Apple Silicon macOS." >&2
  exit 1
fi
if ! command -v mise >/dev/null 2>&1; then
  echo "Install mise first: brew install mise python@3.13" >&2
  exit 1
fi
if ! python3 -c 'import tomllib' >/dev/null 2>&1; then
  echo "Python 3.11 or newer is required: brew install python@3.13" >&2
  exit 1
fi
if ! ruby -e 'exit(Gem::Version.new(RUBY_VERSION) >= Gem::Version.new("3") ? 0 : 1)' >/dev/null 2>&1; then
  echo "Ruby 3 or newer is required for third-party cask metadata: brew install ruby" >&2
  exit 1
fi
case "${1:---dry-run}" in
  --dry-run)
    exec mise bootstrap --dry-run
    ;;
  --backup)
    exec python3 scripts/mise-backup.py
    ;;
  --apply)
    python3 scripts/mise-preflight.py
    python3 scripts/mise-backup.py
    exec mise bootstrap
    ;;
  *)
    echo "Usage: ./setup.sh [--dry-run|--backup|--apply]" >&2
    exit 2
    ;;
esac
