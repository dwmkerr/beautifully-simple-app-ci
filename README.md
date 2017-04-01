# beautifully-simple-app-ci

This repository demonstrates some beautifully simple techniques for handling CI and CI for mobile apps. Each sample project demonstrates the same fundamental techniques, applied to a different combination of technologies and CI/CD providers. Each pipeline can be run locally with ease.

| Sample | CI/CD Provider| App Distribution Technology  | Status |
|--------|---------------|------------------------------|--------|
| [React Native App](./1_react_native_app) | [CircleCI](https://circleci.com/) | [TestFairy](https://testfairy.com/) | [![CircleCI](https://circleci.com/gh/dwmkerr/beautifully-simple-app-ci.svg?style=shield)](https://circleci.com/gh/dwmkerr/beautifully-simple-app-ci) |
| [Ionic 2 Hybrid App](./2_ionic_app) | [TravisCI](https://travis-ci.com/) | [HockeyApp](https://www.hockeyapp.net) | ![TravisCI](https://travis-ci.org/dwmkerr/beautifully-simple-app-ci.svg?branch=master) |
| [Native App](./3_native_app) | BuddyBuild | BuddyBuild | [![BuddyBuild](https://dashboard.buddybuild.com/api/statusImage?appID=58b6e6ddf3eea90100b2e721&branch=master&build=latest)](https://dashboard.buddybuild.com/apps/58b6e6ddf3eea90100b2e721/build/latest?branch=master) |
| [Xamarin App](./4_xamarinapp) | Bitrise | Bitrise | [![Build Status](https://www.bitrise.io/app/8621395af91a1318.svg?token=XsLhdofG35mcLt1CVzT7rw&branch=master)](https://www.bitrise.io/app/8621395af91a1318) |

## Principles to Follow

1. Avoid complex or unnecessary CI/CD tool features. For example, CicleCI can offer Git SHAs via an environment variable, but you can easily grab a SHA with `git info`, so keep things generic.
2. If you DO need a feature, try and keep it out of the makefile. For example, if you need a circle environment variable, pass it via another, generically named environment variable.
3. Any configuration of secrets and special varaibles should be in environment variables. Avoid using 'custom' locations like a `gradle.properties` file, just use profile files. Ensure they are documented.
