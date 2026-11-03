#!/bin/bash
# Explicit opt-in: upstream installer configures Git AI and agent integrations.
set -euo pipefail
trial_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
installer="$(mktemp -t dotfiles-git-ai)"
trap 'rm -f "$installer"' EXIT
curl --fail --location --silent --show-error \
  https://github.com/git-ai-project/git-ai/releases/download/v1.7.5/install.sh \
  --output "$installer"
expected="$(awk '{print $1}' "$trial_root/migration/git-ai-installer.sha256")"
actual="$(shasum -a 256 "$installer" | awk '{print $1}')"
if [[ "$actual" != "$expected" ]]; then
  echo 'Git AI installer checksum mismatch.' >&2
  exit 1
fi
bash "$installer"
