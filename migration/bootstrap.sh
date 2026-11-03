#!/bin/bash
set -euo pipefail
trial_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$trial_root"
case "${1:---dry-run}" in
  --dry-run) trial_mode=--dry-run ;;
  --apply) trial_mode=apply ;;
  *) echo 'Usage: bash migration/bootstrap.sh [--dry-run|--apply]' >&2; exit 2 ;;
esac
if [[ $# -gt 1 ]]; then
  echo 'Usage: bash migration/bootstrap.sh [--dry-run|--apply]' >&2
  exit 2
fi
if [[ "$(uname -s)" != Darwin || "$(uname -m)" != arm64 ]]; then
  echo 'This trial targets Apple Silicon macOS only.' >&2
  exit 1
fi
export PATH="/opt/homebrew/opt/ruby/bin:/opt/homebrew/bin:$PATH"
command -v mise >/dev/null || { echo 'Install prerequisites: brew install mise python@3.13 ruby' >&2; exit 1; }
command -v python3 >/dev/null || { echo 'Python 3.11+ is required for preflight.' >&2; exit 1; }
if [[ "$trial_mode" == apply ]]; then
  python3 migration/validate.py --preflight
  mise bootstrap
else
  python3 migration/validate.py
  mise bootstrap --dry-run
fi
