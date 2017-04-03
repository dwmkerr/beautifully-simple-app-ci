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
elif [ "$(expr substr $(uname -s) 1 5)" == "Linux" ]; then
	# OSX - install ImageMagick.
	apt-get install imagemagick
fi

# Install Node 6.
curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.33.1/install.sh | bash
nvm install 6
nvm use 6

# Try some more installation approaches.

# Install the dependencies.
# brew install imagemagick
# curl https://www.imagemagick.org/download/binaries/ImageMagick-x86_64-apple-darwin16.4.0.tar.gz | tar xvz
# export MAGICK_HOME="$PWD/ImageMagick-x86_64-apple-darwin16.4.0"
# export PATH="$MAGICK_HOME/bin:$PATH"
# export DYLD_LIBRARY_PATH="$MAGICK_HOME/lib/"


# Label the app.
cd 3_native_app
npm install
BUILD_NUM=BUDDYBUILD_BUILD_NUMBER make label
