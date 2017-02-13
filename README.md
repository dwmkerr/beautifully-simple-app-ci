# beautifully-simple-app-ci

This repository demonstrates some beautifully simple techniques for handling CI and CI for mobile apps. Each sample project demonstrates the same fundamental techniques, applied to a different combination of technologies and CI/CD providers. Each pipeline can be run locally with ease.

|-| Sample | App Technology | CI/CD Provider| App Distribution Technology  | Status |
|-|--------|----------------|---------------|------------------------------|--------|
| ![React Native Icon](./article/icon_react_native.png) | [`react_native_app`](./react_native_app) | [React Native](https://facebook.github.io/react-native/) | [CircleCI](https://circleci.com/) | [TestFairy](https://testfairy.com/) | ✅ Android Mac Local ✅ iOS Mac Local ✅ Android CI ❗ iOS CI |

## Principles to Follow

1. Avoid complex or unnecessary CI/CD tool features. For example, CicleCI can offer Git SHAs via an environment variable, but you can easily grab a SHA with `git info`, so keep things generic.
2. If you DO need a feature, try and keep it out of the makefile. For example, if you need a circle environment variable, pass it via another, generically named environment variable.
3. Any configuration of secrets and special varaibles should be in environment variables. Avoid using 'custom' locations like a `gradle.properties` file, just use profile files. Ensure they are documented.
