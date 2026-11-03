#!/bin/bash
# Install only prerequisites; deployment is a separate command.
set -euo pipefail
case "${1:---dry-run}" in
  --dry-run) apply=0 ;;
  --apply) apply=1 ;;
  *) echo 'Usage: bash migration/prepare.sh [--dry-run|--apply]' >&2; exit 2 ;;
esac
[[ $# -le 1 ]] || exit 2
if [[ "$(uname -s)" != Darwin || "$(uname -m)" != arm64 ]]; then
  echo 'This bootstrap targets Apple Silicon macOS.' >&2
  exit 1
fi
if [[ ! -x /opt/homebrew/bin/brew ]]; then
  echo 'Install Homebrew first: https://brew.sh (Xcode command-line tools required).' >&2
  exit 1
fi
for formula in mise python@3.13 ruby; do
  if ! /opt/homebrew/bin/brew list --versions "$formula" >/dev/null 2>&1; then
    if [[ "$apply" == 1 ]]; then
      /opt/homebrew/bin/brew install "$formula"
    else
      echo "Would install: brew install $formula"
    fi
  fi
done
echo 'Next: review mise.toml, then bash migration/bootstrap.sh --dry-run'
