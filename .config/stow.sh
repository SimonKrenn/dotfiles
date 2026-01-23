echo 'creating folders'
mkdir $HOME/.config/fish
mkdir $HOME/.config/nvim
mkdir $HOME/.config/tmux
mkdir $HOME/.config/yazi
mkdir $HOME/.config/git
mkdir $HOME/.config/skhd
mkdir $HOME/.config/lazygit
mkdir $HOME/.config/tmuxinator
mkdir $HOME/.config/atuin
mkdir $HOME/.config/ghostty
mkdir $HOME/.config/hammerspoon
mkdir $HOME/.config/mise
mkdir $HOME/.config/sesh
mkdir $HOME/.config/worktrunk

echo 'stowing files'
stow -v -d $PWD/.config -t $HOME tmux
stow -v -d $PWD/.config -t $HOME/.config/fish fish
stow -v -d $PWD/.config -t $HOME/.config/nvim nvim
stow -v -d $PWD/.config -t $HOME/.config/tmux tmux
stow -v -d $PWD/.config -t $HOME/.config/yazi yazi
stow -v -d $PWD/.config -t $HOME/.config/git git
stow -v -d $PWD/.config -t $HOME/.config/skhd skhd
stow -v -d $PWD/.config -t $HOME/.config/lazygit lazygit
stow -v -d $PWD/.config -t $HOME/.config/tmuxinator tmuxinator
stow -v -d $PWD/.config -t $HOME/.config/ghostty ghostty
stow -v -d $PWD/.config -t $HOME/.config/mise mise
stow -v -d $PWD/.config -t $HOME/.config/atuin atuin --adopt
stow -v -d $PWD/.config -t $HOME/.config/hammerspoon hammerspoon --adopt
stow -v -d $PWD/.config -t $HOME/.config/sesh sesh 
stow -v -d $PWD/.config -t $HOME/.config/opencode opencode --adopt
stow -v -d $PWD/.config -t $HOME/.config/worktrunk worktrunk
