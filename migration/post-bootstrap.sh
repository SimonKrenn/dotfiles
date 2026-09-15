#!/bin/bash
set -euo pipefail
# Called after packages, repositories, dotfiles and mise tools.
# No curl|shell installers and no updates to existing plugin checkouts.
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
echo 'Plugin setup complete. Git identity, app sign-in and optional installers remain manual.'
