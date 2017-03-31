# Set the default parameters for the build, can be overridden with either an
# environment variable or by using `make target KEY=VALUE`.
BUILD_NUM ?= 0
LABEL ?= QA

# Labels the app.
label:
	$(info Labeling icon with '$(LABEL)' and '$(BUILD_NUM)'...)
	./node_modules/.bin/app-icon label -i base-icon.png -o icon.png --top $(LABEL) --bottom $(BUILD_NUM)
	./node_modules/.bin/app-icon generate

# Names the app based on the ENV variable.
name:
	$(info Naming app '$(APP_ID)'...)
	    <string>com.dwmkerr.xamarinapp</string>
	sed 

# Creates the Android APK.
build-android:
	"/Library/Frameworks/Mono.framework/Commands/xbuild" "Droid/xamarinapp.Droid.csproj" "/target:PackageForAndroid" "/p:Configuration=Release"
	mkdir -p ./artifacts
	cp ./Droid/bin/Release/*.apk ./artifacts

# Creates the iOS IPA.
build-ios:
	"/Library/Frameworks/Mono.framework/Commands/xbuild" /p:Configuration="Release" /p:Platform="iPhone" /p:IpaPackageDir="../artifacts/" "/p:BuildIpa=true" xamarinapp.sln
