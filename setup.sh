#!/bin/bash
if [[ "$OSTYPE" == "darwin"* ]]; then
	echo "setting up macos"
	sh ./.config/stow.sh
fi
