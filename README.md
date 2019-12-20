# beautifully-simple-app-ci

This repository demonstrates some beautifully simple techniques for handling CI and CI for mobile apps. It is the companion to my article ['Tips and Tricks for Beautifully Simple Mobile App CI'](http://www.dwmkerr.com/tips-and-tricks-for-beautifully-simple-mobile-app-ci/).

Each sample project demonstrates the same fundamental techniques, applied to a different combination of technologies and CI/CD providers. Each pipeline can be run locally with ease.

| Sample | Build Tool | CI/CD Provider| App Distribution Technology  | Status |
|--------|------------|---------------|------------------------------|--------|
| [React Native App](./1_react_native_app) | Gradle, Gym |  [CircleCI](https://circleci.com/gh/dwmkerr/beautifully-simple-app-ci) | [TestFairy](https://testfairy.com/) | [![CircleCI](https://circleci.com/gh/dwmkerr/beautifully-simple-app-ci.svg?style=shield)](https://circleci.com/gh/dwmkerr/beautifully-simple-app-ci) |
| [Ionic 2 Hybrid App](./2_ionic_app) | Cordova |  [TravisCI](https://travis-ci.org/dwmkerr/beautifully-simple-app-ci) | [HockeyApp](https://www.hockeyapp.net) | [![Build Status](https://travis-ci.org/dwmkerr/beautifully-simple-app-ci.svg?branch=master)](https://travis-ci.org/dwmkerr/beautifully-simple-app-ci) |
| [Native App](./3_native_app) | Gradle, XCode |  [BuddyBuild](https://dashboard.buddybuild.com/apps/58b6e6ddf3eea90100b2e721/build/latest?branch=master) | [BuddyBuild](https://dashboard.buddybuild.com/apps/58b6e6ddf3eea90100b2e721/build/latest?branch=master) | [![BuddyBuild](https://dashboard.buddybuild.com/api/statusImage?appID=58b6e6ddf3eea90100b2e721&branch=master&build=latest)](https://dashboard.buddybuild.com/apps/58b6e6ddf3eea90100b2e721/build/latest?branch=master) |
| [Xamarin App](./4_xamarinapp) | XBuild | [Bitrise](https://www.bitrise.io/app/8621395af91a1318) | [Bitrise](https://www.bitrise.io/app/8621395af91a1318) | [![Build Status](https://www.bitrise.io/app/8621395af91a1318.svg?token=XsLhdofG35mcLt1CVzT7rw&branch=master)](https://www.bitrise.io/app/8621395af91a1318) [![GuardRails badge](https://badges.production.guardrails.io/dwmkerr/beautifully-simple-app-ci.svg)](https://www.guardrails.io) |

## The Commands

There is a project wide `makefile` to quickly build everything:

| Command | Notes |
|---------|--------|
| `make build` | Builds all apps to the `artifacts` folder. |

Here are each of the commands for each of the projects:

**The React Native App**

The source is at [`1_react_native_app`](./1_react_native_app):

```
cd 1_react_native_app
```

| Command | Example | Notes |
|---------|---------|-------|
| `make test` | `make test` | Runs the unit tests. |
| `make build` | `make build` | Builds the apps to the `artifacts` folder. Build specific versions with `build-android` or `build-ios`. |
| `make deploy` | `make deploy` | Deploys apps from the `artifacts` folder to TestFairy. Deploy specific versions with `deploy-android` or `deploy-ios`. |
| `make label` | `make label` | Labels the icon with the current short git SHA. |

**The Cordova App**

The source is at [`2_ionic_app`](./2_ionic_app):

```
cd 2_ionic_app
```

| Command | Example | Notes |
|---------|---------|-------|
| `make test` | `make test` | Runs the tests. Currently a no-op. |
| `make build` | `make build` | Builds the apps to the `artifacts` folder. Build specific versions with `build-android` or `build-ios`. |
| `make deploy` | `make deploy` | Deploys apps from the `artifacts` folder to TestFairy. Deploy specific versions with `deploy-android` or `deploy-ios`. |
| `make label` | `make label BUILD_NUM=2 VERSION=1.2.3` | Labels the icon with the current version (default to what is in `package.json`) and build number (defaults to 0). |

**The Native App**

The source is at [`3_native_app`](./3_native_app):

```
cd 3_native_app
```

| Command | Example | Notes |
|---------|---------|-------|
| `make test` | `make test` | Runs the tests. Currently a no-op. |
| `make label` | `make label BUILD_NUM=2 LABEL=UAT` | Labels the icon with the label (default to QA) and build number (defaults to 0). |

**The Xamarin App**

The source is at [`4_xamarinapp`](./4_xamarinapp):

```
cd 2_xamarinapp
```

| Command | Example | Notes |
|---------|---------|-------|
| `make build` | `make build` | Builds the apps to the `artifacts` folder. Build specific versions with `build-android` or `build-ios`. |
| `make label` | `make label BUILD_NUM=2 ENV=qa` | Labels the icon with the current env (default to `production`) and build number (defaults to 0). |
| `make name` | `make name ENV=qa` | Sets the App ID to `com.dwmkerr.xamarinapp` (default) or `com.dwmkerr.xamarinapp_$(ENV)` otherwise. |
