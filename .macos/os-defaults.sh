defaults write NSGlobalDomain AppleShowAllExtensions -bool true

defaults write com.apple.finder ShowPathbar -bool true

defaults write com.apple.finder ShowStatusBar -bool true

defaults write -g ApplePressAndHoldEnabled -bool true

defaults write com.apple.finder "FXPreferredViewStyle" -string "clmv" 

defaults write com.apple.finder "AppleShowAllFiles" -bool "false"
# show library folder in finder
chflags nohidden ~/Library

#hammerspoon config file location (default is $HOME/.hammerspoon)
defaults write org.hammerspoon.Hammerspoon MJConfigFile "~/.config/hammerspoon/init.lua"
