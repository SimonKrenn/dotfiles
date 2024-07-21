#!/bin/bash
if [[ "$OSTYPE" == "darwin"* ]]; then
	echo "setting up macos"
	sh ./.config/stow.sh
	sh ./.macos/install.sh
	sh ./.macos/os-defaults.sh
fi
