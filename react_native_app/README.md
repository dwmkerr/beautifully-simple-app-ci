# react-native-app [![CircleCI](https://circleci.com/gh/dwmkerr/beautifully-simple-app-ci.svg?style=svg)](https://circleci.com/gh/dwmkerr/beautifully-simple-app-ci)

This app is a demo of the beautifully simple CI/CD process mentioned [here](../README.md).

## Setup

To build the artifacts, you will need:

- XCode 6
- Android Studio (with the `ANDROID_HOME` environment variable set)
- The Android 23.0.1 SDK and Build Tools
- Node 6
- Yarn
- Fastlane Gym
- React Native CLI

```bash
brew update
brew cask install fastlane
brew upgrade openssl
```

You will also need to configure some environment variables. Put the followining in your `.profile`, `.bashrc` or `.zshrc`:

| Environment Variable | Usage |
|----------------------|-------|
| `RNA_KEYSTORE_PASSWORD` | Provides the password for the Android Keystore. For this demo app, should be `p@ssw0rd`. |
| `RNA_CODE_SIGNING_IDENTITY` | The name of your Code Signing Identity (see [Setting up iOS Code Signing](#Setting-up-iOS-Code-Signing)) |
| `TESTFAIRY_API_KEY` | The API key to push to TestFairy. If included, `make deploy` will push the app to TestFairy. If not, the deploy will not proceed. |

## Key Commands

The following commands are useful when working with the project.

| Command | Usage |
|---------|-------|
| `make test` | Runs all of the tests for the project. |
| `make build` | Creates the IPA and APK binaries and saves them in the `./artifacts` folder. |
| `make deploy` | Pushes the binaries to TestFairy. |
| - | - |
| `react-native run-ios` | Runs the app in the iOS emulator. |
| `react-native run-android` | Runs the app in the Android emulator. The emulator must first be running. |

## Initial Setup

The project has been setup like this:

1. Update to XCode 8, installing all commandline tools.
2. Install Android Studio, add `ANDROID_HOME` to the environment variables.
3. Setup the projet with `react-native init react_native_app`.
4. Create a simple [`icon.png`](./icon.png) and generate all sizes with [`react-native-icon`](https://github.com/dwmkerr/react-native-icon).
5. An Android Keystore was created with `keytool -genkey -v -keystore ./android/keystores/app.keystore -alias app -keyalg RSA -keysize 2048 -validity 10000`. The password `p@ssw0rd` was used for both the keysore and app. The passwords were added to the environment variables `REACT_NATIVE_APP_RELEASE_STORE_PASSWORD` and `REACT_NATIVE_APP_RELEASE_KEY_PASSWORD`.
6. The `build.gradle` was updated as per the [React Native - Generating Signed APK](http://facebook.github.io/react-native/releases/0.19/docs/signed-apk-android.html#content) guide.

## Setting up iOS Code Signing

Apple make this hard. From the `./react_native_app` directory, run the following commands:

```bash
mkdir ios/certificates
fastlane cert -u dwmkerr@gmail.com --output_path ios/certificates
```

This will create the certificates, adding them to the `ios/certificates` directory. You will need to have your Apple ID credentials ready. Now create a provisioning profile:

```bash
fastlane sigh --output_path certificates
```

Find the name of the identity, with:

```bash
security find-identity -p codesigning
```

You will see output such as:

```
$ security find-identity -p codesigning

Policy: Code Signing
  Matching identities
  1) 0BF089C1F4BBCF0D84DBB60E3D6BAF29F950974F "iPhone Developer: Dave Kerr (D2TKYQF77R)"
  2) 1878AAC2F053AC1341069BED5A9BA5E0AB0F913D "iPhone Distribution: Dave Kerr (5TTNE9J58F)"
     2 identities found

  Valid identities only
  1) 0BF089C1F4BBCF0D84DBB60E3D6BAF29F950974F "iPhone Developer: Dave Kerr (D2TKYQF77R)"
  2) 1878AAC2F053AC1341069BED5A9BA5E0AB0F913D "iPhone Distribution: Dave Kerr (5TTNE9J58F)"
     2 valid identities found
```

Copy the name of the **iPhone Distribution** identity from the **Valid identities** list, in this case `iPhone Developer: Dave Kerr (D2TKYQF77R)`. You must set the `RNA_CODE_SIGNING_IDENTITY` environment variable to this value.

### Troubleshooting iOS Code Signing

**Application needs signing**

Ensure you've followed the setup steps. Open the XCode Project, go to the build settings and ensure 'Automatically Manage Signing' is disabled. Manually set the release provisioning profile to the one you generated during the setup steps.

Useful references:

- https://circleci.com/docs/ios-code-signing/
- https://facebook.github.io/react-native/releases/0.31/docs/running-on-device-ios.html
