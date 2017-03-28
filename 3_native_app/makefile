# Set the default parameters for the build, can be overridden with either an
# environment variable or by using `make target KEY=VALUE`.
BUILD_NUM ?= 0
LABEL ?= QA

# Tests the code.
test:
	$(warning No tests so far, do not forget to add some in the future.)
	@echo 0

# Labels the app.
label:
	$(info Labeling icon with '$(LABEL)' and '$(BUILD_NUM)'...)
	app-icon label -i base-icon.png -o icon.png --top $(LABEL) --bottom $(BUILD_NUM)
	app-icon generate

# Creates the Android APK.
build-android:
ifndef IA_KEYSTORE_PASSWORD
	$(error No IA_KEYSTORE_PASSWORD is set, cannot build APK.)
endif
	cd android && ./gradlew assembleRelease && cd ..
	cp -f ./android/app/build/outputs/apk/*.apk ./artifacts

deploy-android: bump build-js build-android
	# Push the build to TestFairy.
	curl https://app.testfairy.com/api/upload \
		-F api_key='$(TESTFAIRY_API_KEY)' \
		-F "file=@artifacts/ionic_app.apk" \
		-F auto-update='on' \
		-F metrics='cpu,network,logcat' \
		-F options='shake'


# Creates the iOS IPA.
build-ios:
ifndef IA_CODE_SIGNING_IDENTITY
	$(error No IA_CODE_SIGNING_IDENTITY is set, cannot build IPA.)
endif
	# Recreate the iOS platform.
	rm -rf ./platforms/ios
	cordova platform add ios
	npm run ionic:build
	cordova prepare ios --release
	cd ./platforms/ios; fastlane gym --scheme "ionic_app" \
		--use_legacy_build_api \
		--codesigning_identity "$(RNA_CODE_SIGNING_IDENTITY)"; cd ../..;
