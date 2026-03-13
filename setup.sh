#!/bin/bash
if [[ "$OSTYPE" == "darwin"* ]]; then
	echo "setting up macos"
	sh ./.config/stow.sh
	sh ./.macos/install.sh
	sh ./.macos/os-defaults.sh
fi

# install fisher + plugins
curl -sL https://raw.githubusercontent.com/jorgebucaran/fisher/main/functions/fisher.fish | source && fisher install jorgebucaran/fisher
fisher install PatrickF1/fzf.fish

# install tmux plugin manager
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm


curl -L https://dmtrkovalenko.dev/install-fff-mcp.sh | bash

bun install -g tokscale

#git-ai extension
curl -sSL https://usegitai.com/install.sh | bash
