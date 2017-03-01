# ionic_app [![Build Status](https://travis-ci.org/dwmkerr/beautifully-simple-app-ci.svg?branch=master)](https://travis-ci.org/dwmkerr/beautifully-simple-app-ci)

This app is a demo of the beautifully simple CI/CD process mentioned [here](../README.md). When you have followed the [Setup](#setup) steps, you can use the commands below to work with the project:

| Command | Usage |
|---------|-------|
| `make test` | Runs all of the tests for the project. |
| `make build` | Creates the IPA and APK binaries and saves them in the `./artifacts` folder. |
| `make deploy` | Pushes the binaries to HockeyApp. |
| - | - |
| `ionic serve` | Runs the app in a browser locally. |
| `ionic run android` | Runs the app in the Android emulator. |
| `ionic run ios` | Runs the app in the iOS emulator. |

## Setup Guide

Ensure the follow tools are installed:

| Tool | Notes |
|------|-------|
| XCode | Version 8, with the XCode commandline tools, `xcode-select --install`. |
| Android Studio | Ensure the `ANDROID_HOME` environment variable is set and that the 23.0.1 SDK and build tools are installed. |
| Node 6 | Preferrably installed and managed with [NVM](https://github.com/creationix/nvm). |
| Fastlane | `brew cask install fastlane` |
| Cordova and the Ionic CLI | `npm install -g cordova ionic` |
| JQ | `brew install jq` |

If you want to be able to build and deploy to actual iOS devices, please follow the [Setting up iOS Code Signing](#setting-up-ios-code-signing) guide before continuing to the next step.

You will also need to configure some environment variables. Put the followining in your `.profile`, `.bashrc` or `.zshrc`:

| Environment Variable | Usage |
|----------------------|-------|
| `IA_KEYSTORE_PASSWORD` | Provides the password for the Android Keystore. For this demo app, should be `p@ssw0rd`. |
| `IA_TEAM_ID` | Your team ID (see [Setting up iOS Code Signing](#Setting-up-iOS-Code-Signing)) |
| `IA_HOCKEYAPP_TOKEN` | Your API token for uploading to [HockeyApp](https://www.hockeyapp.net). |

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

Copy the name of the **iPhone Development** team id from the **Valid identities** list, in this case `iPhone Developer: Dave Kerr (D2TKYQF77R)`. You must set the ID in the `IA_TEAM_ID` environment variable to this value (e.g. `export IA_TEAM_ID=D2TKYQF77R`).

## Managing Android Keystores

An Android keystore can be generated with:

```bash
keytool -genkey -v -keystore ./build/android.keystore \
  -alias ionic_app -keyalg RSA -keysize 2048 -validity 10000
```

For this example project, I have used the password `p@ssw0rd` for both the store and the alias.
