# react-native-app

This app is a demo of the beautifully simple CI/CD process mentioned [here](../README.md).

## Initial Setup

The project has been setup like this:

1. Update to XCode 8, installing all commandline tools.
2. Install Android Studio, add `ANDROID_HOME` to the environment variables.
3. Setup the projet with `react-native init react_native_app`.
4. Create a simple [`icon.png`](./icon.png) and generate all sizes with [`react-native-icon`](https://github.com/dwmkerr/react-native-icon).
5. An Android Keystore was created with `keytool -genkey -v -keystore ./android/keystores/app.keystore -alias app -keyalg RSA -keysize 2048 -validity 10000`. The password `p@ssw0rd` was used for both the keysore and app. The passwords were added to the environment variables `REACT_NATIVE_APP_RELEASE_STORE_PASSWORD` and `REACT_NATIVE_APP_RELEASE_KEY_PASSWORD`.
6. The `build.gradle` was updated as per the [React Native - Generating Signed APK](http://facebook.github.io/react-native/releases/0.19/docs/signed-apk-android.html#content) guide.

## Testing

Tests are run with `make test`. This will run the underlying JavaScript tests.

```bash
# This is essentially an alias for `npm test`
make test
```

## Building

Create the APK with `make build-android`.

## TODO

- [ ] Potentially error out of the makefile if the correct environment variables are not set up for the keystore passwords.
