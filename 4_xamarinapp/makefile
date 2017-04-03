# Set the default parameters for the build, can be overridden with either an
# environment variable or by using `make target KEY=VALUE`.
BUILD_NUM ?= 0
ENV ?= production

# Set the app id, with the 'prod' environment implying the unaltered 'base' id.
ifeq ($(ENV),production)
	APP_ID=com.dwmkerr.xamarinapp
else
	APP_ID=com.dwmkerr.xamarinapp_$(ENV)
endif

# Labels the app.
label:
	$(info Labeling icon with '$(ENV)' and '$(BUILD_NUM)'...)
	./node_modules/.bin/app-icon label -i base-icon.png -o icon.png --top $(ENV) --bottom $(BUILD_NUM)
	./node_modules/.bin/app-icon generate

# Names the app based on the ENV variable.
name:
	$(info Naming app '$(APP_ID)'...)
	sed -i.bak 's/com.dwmkerr.xamarinapp.*</$(APP_ID)</' iOS/Info.plist
	sed -i.bak 's/com.dwmkerr.xamarinapp.*\"/$(APP_ID)\"/' Droid/Properties/AndroidManifest.xml

# Creates the Android APK.
build-android:
	"/Library/Frameworks/Mono.framework/Commands/xbuild" "Droid/xamarinapp.Droid.csproj" "/target:PackageForAndroid" "/p:Configuration=Release"
	mkdir -p ./artifacts
	cp ./Droid/bin/Release/com.dwmkerr.xamarinapp.apk ./artifacts/xamarin_app.apk

# Creates the iOS IPA.
build-ios:
	"/Library/Frameworks/Mono.framework/Commands/xbuild" /p:Configuration="Release" /p:Platform="iPhone" /p:IpaPackageDir="../artifacts/" "/p:BuildIpa=true" xamarinapp.sln
	mv ./artifacts/xamarinapp.iOS.ipa ./artifacts/xamarin_app.ipa

# Creates everything.
build: build-android build-ios
