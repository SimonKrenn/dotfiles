fish_add_path /opt/homebrew/bin
starship init fish | source
zoxide init fish --cmd cd| source
direnv hook fish | source
op completion fish | source
fzf --fish | source
atuin init fish | source
# global Aliases

if [ -f $HOME/.config/fish/alias.fish ]
	source $HOME/.config/fish//alias.fish
end

# work aliases 
if [ -f $HOME/.config/fish/private-alias.fish ]
	source $HOME/.config/fish/private-alias.fish
end

# path 
set PATH /Users/int004977/.local/share/bob/nvim-bin/ $PATH

# bun
# set --export BUN_INSTALL "$HOME/.bun"
# set --export PATH $BUN_INSTALL/bin $PATH
fzf_configure_bindings --directory=\cf --variables=\cv

# env vars
set -q XDG_CONFIG_HOME || set -Ux XDG_CONFIG_HOME $HOME/.config
set -q XDG_HOME || set -Ux XDG_HOME $HOME
set -q EDITOR || set -Ux EDITOR nvim

# Created by `pipx` on 2025-04-21 18:22:51
set PATH $PATH /Users/int004977/.local/bin
