#!/bin/bash
set -euo pipefail
export PATH="/opt/homebrew/opt/ruby/bin:/opt/homebrew/bin:/opt/homebrew/sbin:$PATH"

repo_dir="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
cd "$repo_dir"

if [[ "$(uname -s)" != "Darwin" || "$(uname -m)" != "arm64" ]]; then
  echo "This bootstrap currently targets Apple Silicon macOS." >&2
  exit 1
fi
# Backups only need Python; mise and Ruby are required for bootstrap.
if ! python3 -c 'import tomllib' >/dev/null 2>&1; then
  echo "Python 3.11 or newer is required: brew install python@3.13" >&2
  exit 1
fi
if [[ $# -gt 1 ]]; then
  echo "Usage: ./setup.sh [--dry-run|--backup|--apply]" >&2
  exit 2
fi
case "${1:---dry-run}" in
  --backup) exec python3 scripts/mise-backup.py ;;
  --dry-run) set -- --dry-run ;;
  --apply) set -- ;;
  *)
    echo "Usage: ./setup.sh [--dry-run|--backup|--apply]" >&2
    exit 2
    ;;
esac

if ! command -v mise >/dev/null 2>&1; then
  echo "Install mise first: brew install mise python@3.13" >&2
  exit 1
fi
if ! ruby -e 'exit(Gem::Version.new(RUBY_VERSION) >= Gem::Version.new("3") ? 0 : 1)' >/dev/null 2>&1; then
  echo "Ruby 3 or newer is required for third-party cask metadata: brew install ruby" >&2
  exit 1
fi
# The pre-dotfiles hook owns preflight and backup for both entry points:
# mise bootstrap and mise dot apply.
exec mise bootstrap "$@"
