# beautifully-simple-app-ci

This repository demonstrates some beautifully simple techniques for handling CI and CI for mobile apps. These techniques are applicable to many mobile technologies and development platforms and compliment many different CI/CD toolchains.

Each project demonstrates the same fundamental techniques, applied to a different combination of technologies and CI/CD providers. Each pipeline can be run locally with ease.

| Sample | App Technology | App Distribution Technology | CI/CD Provider |
|--------|----------------|-----------------------------|----------------|
| [`react-native`](./react-native) | [React Native](https://facebook.github.io/react-native/) | [TestFairy](https://testfairy.com/) | [CircleCI](https://circleci.com/) |

## The React Native App

The React Native app was set up using `react-native init` (see the [React Native Getting Started](https://facebook.github.io/react-native/docs/getting-started.html) guide).

The only adaptations are:

1. The addition of a single, simple icon file.
2. Incorportation of CircleCI.
3. Setup of TestFairy.
4. Orchestration of the CI/CD via the `makefile`.
:q
a
:qa
