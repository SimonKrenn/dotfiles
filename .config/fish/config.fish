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

# functions
if [ -f $HOME/.config/fish/functions.fish ]
source $HOME/.config/fish/functions.fish
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

# Added by LM Studio CLI (lms)
set -gx PATH $PATH /Users/int004977/.lmstudio/bin
# End of LM Studio CLI section


# amp
fish_add_path "~/.local/bin"
fish_add_path $HOME/.local/bin

# Added by git-ai installer on Tue Mar  3 13:31:21 CET 2026
fish_add_path -g "/Users/int004977/.git-ai/bin"

# global bun executables 
fish_add_path "/Users/simonkrenn/.bun/bin"


# Added by git-ai installer on Fri Mar 13 17:11:34 CET 2026
fish_add_path -g "/Users/simonkrenn/.git-ai/bin"

fish_add_path -g "/Users/simonkrenn/.browser-use/bin"
fish_add_path -g "/Users/simonkrenn/.browser-use-env/bin"





