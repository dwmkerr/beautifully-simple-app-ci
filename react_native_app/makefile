# Get key SHA, Branch and Tag data.
GIT_SHORT_SHA := $(shell git log -1 --format="%h")

# Bundle
BUNDLE_ID=org.reactjs.native.example.react-native-app

setup:
	(cd ios; /
		fastlane cert --username $(APPLE_USERNAME); /
		produce -u dwmkerr@gmail.com -a org.reactjs.native.example.react-native-app --skip_itc
		fastlane sign --username $(APPLE_USERNAME) --app_identifier $(BUNDLE_ID); /
	)

# Test should run all project tests.
test:
	npm test

# Builds the APK to the artifacts folder.
build-android:
	cd android && ./gradlew assembleRelease && cd ..
	mv -f ./android/app/build/outputs/apk/app-release.apk ./artifacts

# Builds the IPA to the artifacts folder.
build-ios:
	react-native bundle --dev false --entry-file index.ios.js --bundle-output ios/main.jsbundle --platform ios
	cd ./ios; fastlane gym --scheme "react_native_app" --codesigning_identity "$(REACT_NATIVE_APP_CODESIGN_IDENTITY)" --use_legacy_build_api



# Builds the app binaries to the artifacts folder.
build: build-android build-ios

# Deploys the apps to TestFairy.
deploy:
	$(error Not implmented)
