fish_add_path /opt/homebrew/bin
starship init fish | source


# Aliases
if [ -f $HOME/.config/fish/alias.fish ]
    source $HOME/.config/fish//alias.fish
end

# bun
set --export BUN_INSTALL "$HOME/.bun"
set --export PATH $BUN_INSTALL/bin $PATH
