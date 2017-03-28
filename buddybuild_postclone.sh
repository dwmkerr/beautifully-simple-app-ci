#!/usr/bin/env bash

# BuddyBuild will get confused if it sees all of these apps! So start
# by removing all the example apps except '3_native_app'.
rm -rf 1_react_native_app/
rm -rf 2_ionic_app/
rm -rf 4_xamarinapp/

# Label the app.
cd 3_native_app
BUILD_NUM=BUDDYBUILD_BUILD_NUMBER make label
