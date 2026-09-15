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
  echo 'Extra flags are refused (especially force/yes).' >&2
  exit 2
fi
if [[ "$(uname -s)" != Darwin || "$(uname -m)" != arm64 ]]; then
  echo 'This trial targets Apple Silicon macOS only.' >&2
  exit 1
fi
command -v mise >/dev/null || { echo 'Install a bootstrap-capable mise first.' >&2; exit 1; }
command -v python3 >/dev/null || { echo 'Python 3.11+ is required for preflight.' >&2; exit 1; }
python3 migration/validate.py
mise bootstrap --help >/dev/null
if [[ "$trial_mode" == apply ]]; then
  if [[ "${DOTFILES_MISE_TRIAL_APPLY:-}" != 1 ]]; then
    echo 'Read migration/README.md; then explicitly set DOTFILES_MISE_TRIAL_APPLY=1.' >&2
    exit 1
  fi
  python3 migration/validate.py --preflight
  mise bootstrap
else
  mise bootstrap --dry-run
fi
