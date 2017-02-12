# beautifully-simple-app-ci

This repository demonstrates some beautifully simple techniques for handling CI and CI for mobile apps. These techniques are applicable to many mobile technologies and development platforms and compliment many different CI/CD toolchains.

Each project demonstrates the same fundamental techniques, applied to a different combination of technologies and CI/CD providers. Each pipeline can be run locally with ease.

| Sample | App Technology | App Distribution Technology | CI/CD Provider | Status |
|--------|----------------|-----------------------------|----------------|--------|
| [`react-native`](./react-native) | [React Native](https://facebook.github.io/react-native/) | [TestFairy](https://testfairy.com/) | [CircleCI](https://circleci.com/) [![CircleCI](https://circleci.com/gh/dwmkerr/beautifully-simple-app-ci.svg?style=svg)](https://circleci.com/gh/dwmkerr/beautifully-simple-app-ci) | ❗ Android Mac Local ❗ iOS Mac Local ❗ Android CI ❗ iOS CI |

## The React Native App

The React Native app was set up using `react-native init` (see the [React Native Getting Started](https://facebook.github.io/react-native/docs/getting-started.html) guide).

The only adaptations are:

1. The addition of a single, simple icon file.
2. Incorportation of CircleCI.
3. Setup of TestFairy.
4. Orchestration of the CI/CD via the `makefile`.

## Principles to Follow

1. Avoid complex or unnecessary CI/CD tool features. For example, CicleCI can offer Git SHAs via an environment variable, but you can easily grab a SHA with `git info`, so keep things generic.
2. If you DO need a feature, try and keep it out of the makefile. For example, if you need a circle environment variable, pass it via another, generically named environment variable.
3. Any configuration of secrets and special varaibles should be in environment variables. Avoid using 'custom' locations like a `gradle.properties` file, just use profile files. Ensure they are documented.
