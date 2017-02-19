# Set the default parameters for the build, can be overridden with either an
# environment variable or by using `make target KEY=VALUE`.
VERSION ?= $(shell cat package.json | jq --raw-output .version)
BUILD_NUM ?= 0

debug:
	echo "version $(VERSION)"

# Touch will ensure that all version numbers are consistent, based on the
# package.json version.
touch:
  # Set the version and build number in the config file.
	sed -i "" -e 's/android-versionCode=\"[0-9]*\"/android-versionCode=\"$(BUILD_NUM)\"/g' ./config.xml
	sed -i "" -e 's/ios-CFBundleVersion=\"[0-9]*\"/ios-CFBundleVersion=\"$(BUILD_NUM)\"/g' ./config.xml
	sed -i "" -e 's/version=\"[.0-9a-zA-Z]*\"/version=\"$(VERSION)"/g' ./config.xml

# Tests the code.
test:
	npm run test

# Creates the Android APK.
build-android:
ifndef IA_KEYSTORE_PASSWORD
	$(error No IA_KEYSTORE_PASSWORD is set, cannot build APK.)
endif
	# Recreate the Android platform.
	npm run ionic:build
	rm -rf ./platforms/android
	cordova platform add android
	cordova build android --release
	cp platforms/android/build/outputs/apk/*.apk ./artifacts/ionic_app.apk
	jarsigner -verbose -sigalg SHA1withRSA -digestalg SHA1 \
		-keystore ./build/ionic_app.keystore \
		-storepass $(IA_KEYSTORE_PASSWORD) -keypass $(IA_KEYSTORE_PASSWORD) \
			"./artifacts/ionic_app.apk" ionic_app

deploy-android: bump build-js build-android
	# Push the build to TestFairy.
	curl https://app.testfairy.com/api/upload \
		-F api_key='$(TESTFAIRY_API_KEY)' \
		-F "file=@artifacts/ionic_app.apk" \
		-F auto-update='on' \
		-F metrics='cpu,network,logcat' \
		-F options='shake'
