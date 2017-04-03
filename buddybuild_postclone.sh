#!/usr/bin/env bash

# BuddyBuild will get confused if it sees all of these apps! So start
# by removing all the example apps except '3_native_app'.
rm -rf 1_react_native_app/
rm -rf 2_ionic_app/
rm -rf 4_xamarinapp/

# Install ImageMagick on OSX.
if [ "$(uname)" == "Darwin" ]; then
	# OSX - install HomeBrew and then ImageMagick.
	/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
	brew install imagemagick
    # Install Node 6. Required for labelling.

    curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.33.1/install.sh | bash
    export NVM_DIR="$HOME/.nvm"
    [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
    nvm install 6
    nvm use 6

    # Label the app.
    cd 3_native_app
    npm install
    BUILD_NUM=$BUDDYBUILD_BUILD_NUMBER make label

elif [ "$(expr substr $(uname -s) 1 5)" == "Linux" ]; then
    # Currently when we try to label the icon with ImageMagick, we get font
    # errors, so we skip it for now.
    echo "Checking ImageMagick version..."
    convert -showversion
    echo "Skipping ImageMagick installation..."
fi

