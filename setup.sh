#!/bin/bash
if [[ "$OSTYPE" == "darwin"* ]]; then
	echo "setting up macos"
	sh ./.macos/setup.sh
fi
