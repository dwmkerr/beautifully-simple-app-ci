# Get key SHA, Branch and Tag data.
GIT_SHORT_SHA := $(shell git log -1 --format="%h")

# Test should run all project tests.
test:
	npm test

# Builds the APK to the artifacts folder.
build-android:
	cd android && ./gradlew assembleRelease && cd ..
	mv -f ./android/app/build/outputs/apk/app-release.apk ./artifacts

# Builds the IPA to the artifacts folder.
build-ios:
	$(warning Work in progress)

# Builds the app binaries to the artifacts folder.
build: build-android build-ios

# Deploys the apps to TestFairy.
deploy:
	$(error Not implmented)
