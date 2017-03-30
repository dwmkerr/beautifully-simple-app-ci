# Get key SHA, Branch and Tag data.
GIT_SHORT_SHA := $(shell git log -1 --format="%h")

# Test should run all project tests.
test:
	npm test

# Labels the app.
label:
	$(info Labeling icon with '$(GIT_SHORT_SHA)'...)
	./node_modules/.bin/app-icon label -i base-icon.png -o icon.png --bottom $(GIT_SHORT_SHA)
	./node_modules/.bin/app-icon generate

# Builds the APK to the artifacts folder.
build-android:
	cd android && ./gradlew assembleRelease && cd ..
	cp -f ./android/app/build/outputs/apk/app-release.apk ./artifacts

# Builds the IPA to the artifacts folder.
build-ios:
ifndef RNA_CODE_SIGNING_IDENTITY
	$(error No RNA_CODE_SIGNING_IDENTITY is set, cannot build IPA.)
endif
	react-native bundle --dev false --entry-file index.ios.js --bundle-output ios/main.jsbundle --platform ios
	cd ./ios; fastlane gym --scheme "react_native_app" --codesigning_identity "$(RNA_CODE_SIGNING_IDENTITY)"; cd ../;
	cp -f ./ios/react_native_app.ipa ./artifacts

# Deploys the apps to TestFairy.
deploy-android:
ifndef TESTFAIRY_API_KEY
	$(error No TESTFAIRY_API_KEY is set, cannot deploy to TestFairy.)
endif
	# Push the build to TestFairy.
	curl https://app.testfairy.com/api/upload \
		-F api_key='$(TESTFAIRY_API_KEY)' \
		-F "file=@./artifacts/app-release.apk" \
		-F auto-update='on' \
		-F metrics='cpu,network,logcat' \
		-F options='shake'

# Deploys the apps to TestFairy.
deploy-ios:
ifndef TESTFAIRY_API_KEY
	$(error No TESTFAIRY_API_KEY is set, cannot deploy to TestFairy.)
endif
	# Push the build to TestFairy.
	curl https://app.testfairy.com/api/upload \
		-F api_key='$(TESTFAIRY_API_KEY)' \
		-F "file=@./artifacts/react_native_app.ipa" \
		-F auto-update='on' \
		-F metrics='cpu,network,logcat' \
		-F options='shake'
