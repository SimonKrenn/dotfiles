RED="$(tput setaf 1)"
NORMAL="$(tput sgr0)"

function colorEcho () {
    printf "${RED} $1${NORMAL}\n"
}

colorEcho "Cloning dotfiles..."
git clone git@github.com:SimonKrenn/dotfiles.git
chmod +x ~/dotfiles/bin/*

colorEcho "Setup some OSX settings..."
sh ~/dotfiles/bin/osx.sh 2>&1 > /dev/null

colorEcho "Installing home brew..."
/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
brew tap homebrew/core
brew tap homebrew/versions
brew tap caskroom/fonts

colorEcho "Brew install..."
brew install git
brew install tig
brew install vim
brew install neovim
brew install fzf
brew install youtube-dl
brew install httpie
brew install ranger
brew install tmux
brew install ncurses
brew install fdupes
brew install pdfgrep
brew install htop
brew install idea
brew install iotop
brew install yank
brew install z
brew install nshift
brew install itunes-remote
brew install tag
brew install football-cli
brew install nehm
brew install oysttyer
brew install themer
brew install boilr
brew install s
brew install google-font-installer
brew install gifgen
brew install amethyst
brew install node


colorEcho "Installing apps using brew cask..."
brew cask install alfred
brew cask install google-chrome
brew cask install iterm2-nightly
brew cask install mattr-slate
brew cask install webstorm
brew cask install postman
brew cask install sketch
brew cask install netbeans
brew cask install android-studio
brew cask install intellij-idea
brew cask install atom
brew cask install dropbox
brew cask install tunnelblick
brew cask install filezilla
brew cask install übersicht
brew cask install vlc
brew cask install docker
brew cask install slack
brew cask install discord
brew cask install gyazo
brew cask install 1password
brew cask install shazam
brew cask install captain
brew cask install latexit
brew cask install zotero


colorEcho "Installing node global modules..."
npm i -g gulp
npm i -g eslint
npm i -g how2
npm i -g vtop
npm i -g nodemon
npm i -g yarn
npm i -g is-up
npm i -g caniuse-cmd
npm i -g hget
npm i -g @angular/cli
npm i -g polymer-cli
npm i -g bower


colorEcho "Install and setup oh-my-zsh..."
git clone https://github.com/chriskempson/base16-shell.git ~/.config/base16-shell
sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
mkdir ~/.oh-my-zsh/custom/themes/
ln -s ~/dotfiles/templates/goschevski.zsh-theme ~/.oh-my-zsh/custom/themes/goschevski.zsh-theme

colorEcho "Setup homefiles..."
for file in $(ls ~/dotfiles/homefiles/)
do
    rm -rf ~/.$file
    ln -s ~/dotfiles/homefiles/$file ~/.$file
done

colorEcho "Setup vim"
curl -fLo ~/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
vim +PlugInstall +qall
