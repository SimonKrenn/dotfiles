fish_add_path /opt/homebrew/bin
starship init fish | source
zoxide init fish | source
direnv hook fish | source
# global Aliases
if [ -f $HOME/.config/fish/alias.fish ]
	source $HOME/.config/fish//alias.fish
end

# work aliases 
if [ -f $HOME/.config/fish/private-alias.fish ]
	source $HOME/.config/fish/private-alias.fish
end

# bun
# set --export BUN_INSTALL "$HOME/.bun"
# set --export PATH $BUN_INSTALL/bin $PATH


# env vars
export EDITOR=nvim
