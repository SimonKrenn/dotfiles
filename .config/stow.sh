echo 'creating folders'
mkdir $HOME/.config/fish
mkdir $HOME/.config/alacritty
mkdir $HOME/.config/nvim
mkdir $HOME/.config/tmux
mkdir $HOME/.config/yazi
mkdir $HOME/.config/git
mkdir $HOME/.config/skhd
mkdir $HOME/.config/lazygit

	echo 'stowing files'
	stow -v -d $PWD/.config -t $HOME tmux
	stow -v -d $PWD/.config -t $HOME/.config/fish fish
	stow -v -d $PWD/.config -t $HOME/.config/alacritty alacritty
	stow -v -d $PWD/.config -t $HOME/.config/nvim nvim
	stow -v -d $PWD/.config -t $HOME/.config/tmux tmux
	stow -v -d $PWD/.config -t $HOME/.config/yazi yazi
	stow -v -d $PWD/.config -t $HOME/.config/git git
	stow -v -d $PWD/.config -t $HOME/.config/skhd skhd
	stow -v -d $PWD/.config -t $HOME/.config/lazygit lazygit
