#!/bin/bash
set -euo pipefail
trial_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
export PATH="/opt/homebrew/bin:$HOME/.local/share/bob/nvim-bin:$PATH"
nvim_version="$(cat "$trial_root/migration/neovim-version")"
if [[ ! -x "$HOME/.local/share/bob/nvim-bin/nvim" ]] || \
  [[ "$("$HOME/.local/share/bob/nvim-bin/nvim" --version | head -n 1)" != "NVIM v$nvim_version" ]]; then
  bob use "$nvim_version"
fi

# Only reinstall when manifests change or modules disappear.
opencode_dir="$HOME/.config/opencode"
dependency_hash="$(cat "$opencode_dir/package.json" "$opencode_dir/package-lock.json" | shasum -a 256 | awk '{print $1}')"
stamp="$opencode_dir/node_modules/.dotfiles-dependencies.sha256"
if [[ ! -f "$stamp" ]] || [[ "$(cat "$stamp")" != "$dependency_hash" ]] || \
  [[ ! -d "$opencode_dir/node_modules/@opencode-ai/plugin" ]]; then
  npm ci --prefix "$opencode_dir" --ignore-scripts --no-audit --no-fund
  echo "$dependency_hash" > "$stamp"
fi

# Homebrew Fisher is autoloaded by Fish.
fish -c 'functions -q fisher; or exit 1'
fish -c '
  for plugin in (string match -rv "^\\s*(#|\$)" < ~/.config/fish/fish_plugins)
    if not contains -- $plugin (fisher list)
      fisher install $plugin; or exit 1
    end
  end
'
if [[ ! -f "$HOME/.tmux/plugins/tpm/bin/install_plugins" ]]; then
  echo 'TPM checkout missing; run the repos phase first.' >&2
  exit 1
fi
# Separate server: do not reload or kill the real tmux server.
trial_socket="dotfiles-mise-trial-$$"
trap 'tmux -L "$trial_socket" kill-server 2>/dev/null || true' EXIT
tmux -L "$trial_socket" -f "$HOME/.config/tmux/tmux.conf" new-session -d -s bootstrap
tmux -L "$trial_socket" run-shell "$HOME/.tmux/plugins/tpm/bin/install_plugins"
if [[ -d "$HOME/Library" ]]; then
  chflags nohidden "$HOME/Library"
fi
echo 'Setup complete. Configure local Git email, app sign-in and accessibility permissions.'
