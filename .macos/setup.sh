echo "installing homebrew formulae"
sh ./install.sh

echo "setting up symlinks"
sh ./stow.sh

echo "set os-defaults"
sh ./os-defaults.sh

echo "set fish as default shell"
echo "/opt/homebrew/bin/fish" | sudo tee -a /etc/shells
chsh -s /opt/homebrew/bin/fish
