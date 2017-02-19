# react-native-app [![CircleCI](https://circleci.com/gh/dwmkerr/beautifully-simple-app-ci.svg?style=svg)](https://circleci.com/gh/dwmkerr/beautifully-simple-app-ci)

This app is a demo of the beautifully simple CI/CD process mentioned [here](../README.md). When you have followed the [Setup Guide](#setup-guide) steps, you can use the commands below to work with the project:

| Command | Usage |
|---------|-------|
| `make test` | Runs all of the tests for the project. |
| `make build` | Creates the IPA and APK binaries and saves them in the `./artifacts` folder. |
| `make deploy` | Pushes the binaries to TestFairy. |
| - | - |
| `react-native run-ios` | Runs the app in the iOS emulator. |
| `react-native run-android` | Runs the app in the Android emulator. The emulator must first be running. |

## Setup Guide

Ensure the follow tools are installed:

| Tool | Notes |
|------|-------|
| XCode | Version 8, with the XCode commandline tools, `xcode-select --install`. |
| Android Studio | Ensure the `ANDROID_HOME` environment variable is set and that the 23.0.1 SDK and build tools are installed. |
| Node 6 | Preferrably installed and managed with [NVM](https://github.com/creationix/nvm). |
| Yarn | `npm install -g yarn` |
| Fastlane | `brew cask install fastlane` |
| React Native CLI | `npm install -g react-native-cli` |

If you want to be able to build and deploy to actual iOS devices, please follow the [Setting up iOS Code Signing](#setting-up-ios-code-signing) guide before continuing to the next step.

You will also need to configure some environment variables. Put the followining in your `.profile`, `.bashrc` or `.zshrc`:

| Environment Variable | Usage |
|----------------------|-------|
| `RNA_KEYSTORE_PASSWORD` | Provides the password for the Android Keystore. For this demo app, should be `p@ssw0rd`. |
| `RNA_CODE_SIGNING_IDENTITY` | The name of your Code Signing Identity (see [Setting up iOS Code Signing](#Setting-up-iOS-Code-Signing)) |
| `TESTFAIRY_API_KEY` | The API key to push to TestFairy. If included, `make deploy` will push the app to TestFairy. If not, the deploy will not proceed. |

## Setting up iOS Code Signing

You will only be able to setup iOS Code Signing if you have enrolled in the [Apple Developer Program](https://developer.apple.com/programs/). If you have, follow the steps below.

From the `./react_native_app` directory, run the following commands:

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

## Appendix 1: Initial Setup

The project was intially setup like this:

1. Update to XCode 8, installing all commandline tools.
2. Install Android Studio, add `ANDROID_HOME` to the environment variables.
3. Setup the projet with `react-native init react_native_app`.
4. Create a simple [`icon.png`](./icon.png) and generate all sizes with [`react-native-icon`](https://github.com/dwmkerr/react-native-icon).
5. An Android Keystore was created with `keytool -genkey -v -keystore ./android/keystores/app.keystore -alias app -keyalg RSA -keysize 2048 -validity 10000`. The password `p@ssw0rd` was used for both the keysore and app. The passwords were added to the environment variables `REACT_NATIVE_APP_RELEASE_STORE_PASSWORD` and `REACT_NATIVE_APP_RELEASE_KEY_PASSWORD`.
6. The `build.gradle` was updated as per the [React Native - Generating Signed APK](http://facebook.github.io/react-native/releases/0.19/docs/signed-apk-android.html#content) guide.
