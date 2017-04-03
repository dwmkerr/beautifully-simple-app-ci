#!/usr/bin/env bash

# BuddyBuild will get confused if it sees all of these apps! So start
# by removing all the example apps except '3_native_app'.
rm -rf 1_react_native_app/
rm -rf 2_ionic_app/
rm -rf 4_xamarinapp/

# Try some more installation approaches.
/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
brew install imagemagick

# Install the dependencies.
# brew install imagemagick
curl https://www.imagemagick.org/download/binaries/ImageMagick-x86_64-apple-darwin16.4.0.tar.gz | tar xvz
export MAGICK_HOME="$PWD/ImageMagick-x86_64-apple-darwin16.4.0"
export PATH="$MAGICK_HOME/bin:$PATH"
export DYLD_LIBRARY_PATH="$MAGICK_HOME/lib/"


# Label the app.
cd 3_native_app
npm install
BUILD_NUM=BUDDYBUILD_BUILD_NUMBER make label
