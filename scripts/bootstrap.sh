#!/user/bin/env bash
set -euo pipefail

log() {
  echo "[dotfiles] $*"
}

OS="$(uname)"
ARCH="$(uname -m)"

HOSTNAME="$1"
DOTFILES_DIR="$HOME/workspace/dotfiles"
DOTFILES_BRANCH="main"
DOTFILES_REPO="https://github.com/SimonKrenn/dotfiles.git"


if [[ -e "$DOTFILES_DIR" ]]; then
  log "Target directory already exists: $DOTFILES_DIR"
  exit 1
fi

if ! xcode-select -p >/dev/null 2>&1; then
  log "Installing xcode commandline tools..."
  xcode-select --install || true
  log "re-run after CLT installation finishes."
  exit 0
fi

if ! command -v nix >/dev/null 2>&1; then
  log "installing Determinate Nix"
  curl -fsSL https://install.determinate.systems/nix | sh -s -- install
fi

if [[ -d "$DOTFILES_DIR/.git" ]]; then
  log "Updating dotfiles repo..."
  git -C "$DOTFILES_DIR" fetch origin "$DOTFILES_BRANCH"
  git -C "$DOTFILES_DIR" checkout "$DOTFILES_BRANCH"
  git -C "$DOTFILES_DIR" pull --ff-only origin "$DOTFILES_BRANCH"
else
  log "Cloning dotfiles into $DOTFILES_DIR..."
  mkdir -p "$(dirname "$DOTFILES_DIR")"
  git clone --branch "$DOTFILES_BRANCH" "$DOTFILES_REPO" "$DOTFILES_DIR"
fi

log "Activating nix-darwin/home-manager for $HOSTNAME"
cd "$DOTFILES_DIR"
nix run nix-darwin -- switch --flake ".#$HOSTNAME"

log "Done"
