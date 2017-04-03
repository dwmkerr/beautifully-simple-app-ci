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
	./node_modules/.bin/app-icon label -i base-icon.png -o icon.png --top $(LABEL) --bottom $(BUILD_NUM)
	./node_modules/.bin/app-icon generate

# Builds the APK to the artifacts folder.
build-android:
	cd android && ./gradlew assembleRelease && cd ..
	cp -f ./android/native_app/build/outputs/apk/native_app-release-unsigned.apk ./artifacts/native_app-unsigned.apk
