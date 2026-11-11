#!/bin/bash
set -euo pipefail
export PATH="/opt/homebrew/bin:/opt/homebrew/sbin:$PATH"

# Install Fisher and the declared plugins only when their functions are missing.
fish -c '
  if not functions -q fisher
    source /opt/homebrew/share/fish/vendor_functions.d/fisher.fish
  end
  set -l missing 0
  for plugin in jorgebucaran/fisher patrickf1/fzf.fish
    if not contains -- $plugin (fisher list)
      set missing 1
    end
  end
  if test $missing -eq 1
    fisher update
  end
'

if [[ ! -d "$HOME/.tmux/plugins/tpm/.git" ]]; then
  git clone https://github.com/tmux-plugins/tpm "$HOME/.tmux/plugins/tpm"
fi
# TPM reads the deployed tmux configuration and skips plugins already installed.
# Install through prefix + I in an active tmux session after bootstrap.
chflags nohidden "$HOME/Library"
