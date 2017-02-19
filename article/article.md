CI and CD for mobile apps can be challenging. Creating signed apps requires a fair amount of setup, as well as the management of secrets, certificates, keystores, provisioning profiles and so on.

In this article I'm going to demonstrate some simple tips and tricks, which will help you build and maintain beautifully simple mobile CI, regardless of the underlying technology.

## The Basic CI Pipeline

Conceptually, a CI pipeline is pretty simple:

![Basic CI Pipeline](/content/images/2017/02/1-basic-ci.png)

We take our code, perform some kind of validation (such as testing, linting, whatever), generate our artifacts and then deploy them to some devices.

Often though there's a bit more to it than that:

![Basic CI is not Basic](/content/images/2017/02/2-basic-not-basic-1.png)

Our source code has some metadata associated with it at the point in time you create your binaries, such as:

- The SHA, which uniquely identifies your exact location in the source history.
- The branch, which may have some *semantic* meaning for your project, for example `master` meaning 'production' or `alpha` meaning your current unstable public build.
- A tag, which may represent something like a semver, or may have more project-specific meaning.
- A version, which might be in something like a `package.json` or embedded in your project files for iOS or Android.

We might also try to keep some kind of build number, to track which build created a set of binaries.

On the apps themselves, we have things like:

- Package names and bundle ids, which theoretically should be unique on a device, causing headaches if you are going to install multiple *versions* of an app (e.g. dev and UAT builds)
- A build number and version number

Ideally we want our CI to keep everything in sync. If I have an app running on a user's device, it should have a version number which is related to the code and we should be able to see the exact SHA from which the apps were created.

So even the 'basic' CI isn't all that basic. Before we dive into some specific tricks for managing these challenges we should first establish some basic principles for mobile app CI.

## Principles

Some general principles it can be useful to follow are below. 

- Developers should be able to run all of the key CI steps on their local machine, to be able to understand, adapt and develop the process.
- When building more complex features, we should create small, simple units of work which can be composed into larger pipelines
- Complexity, if needed, is in code - not in 'black box' CI tools.

## Tip 1 - Embrace Makefiles

There are a raft of platform and framework specific tools and interfaces we will have to use in mobile projects. XCode, Gradle, NPM, framework specific CLIs, tools such as Fastlane, etc etc.

If you ensure that your main 'entrypoint' to key operations is a recipe in a makefile, you can provide a degree of consistency to mobile projects. For example:

- `make build` - Creates an IPA and APK, saving them to the `./artifacts` folder.
- `make tests` - Runs all test suites; perfect for CI.
- `make deploy` - Deploys the binaries.

A `makefile` for such commands might look like this:

```
test:
    # Run all the tests.
    npm test

build:
    # Create the apk, copy to artifacts.
    cd android && ./gradlew assembleRelease && cd ..
    cp -f ./android/app/build/outputs/apk/myapp-release.apk ./artifacts
    
    # Create the ipa, copy to artifacts.
    cd ./ios; fastlane gym --scheme "app" --codesigning_identity "$(CODE_SIGNING_IDENTITY)"; cd ../;
    cp -f ./ios/myapp.ipa ./artifacts

deploy:
    # Push to TestFairy.
    curl https://app.testfairy.com/api/upload \
        -F api_key='$(API_KEY)' \
        -F "file=@./artifacts/app-release.apk"
```

This is a slightly shortened snippet, you can see a working example here:

[github.com/dwmkerr/beautifully-simple-app-ci/tree/master/1_react_native_app](https://github.com/dwmkerr/beautifully-simple-app-ci/tree/master/1_react_native_app)

This example demonstrates using makefiles to handle key commands for a React Native app. CircleCI is used to handle automatic builds on code changes, and the apps themselves are distributed automatically to testers' devices with TestFairy.

The [`README.md`](https://github.com/dwmkerr/beautifully-simple-app-ci/blob/master/1_react_native_app/README.md) immediately draws attention to the makefile commands:

![Screenshot of the README.md file](/content/images/2017/02/3-tip1-readme.png)

The makefiles do most of the work, that makes setting up CircleCI almost trivial. Here's a snippet of its config:

```
general:
  artifacts:
    - ./artifacts

test:
  override:
    - make build-android
    - make test

deployment:
  master:
    branch: [master]
    commands:
      - make deploy-android
```

Our commands are android specific at this stage as Circle don't support iOS builds on their free plan, however I've successfully used this approach to build Android *and* iOS from the same OSX build agent on their paid plan on a number of projects.

The CI automatically tests and builds whenever we have new code commits:

![Screenshot of CircleCI and the artifacts](/content/images/2017/02/4-tip1-circle.png)

Also, if a commit is made to the `master` branch, our new app is automatically pushed to TestFairy, which can be configured to automatically update the test team:

![Screenshot of TestFairy](/content/images/2017/02/5-tip1-testfairy.png)

**In Summary**

- Makefiles allow you to provide an entrypoint for common app CI tasks which is framework and toolkit agnostic
- Being able to run the individual *steps* of a CI build on a local machine makes it easier for developers to work with the pipeline
- By having a CI platform only need to handle the orchestration of these simple steps, we are less tied to specific platforms and can reduce lock-in

We'll see more interesting makefile recipes as we get into the other tips.

## Tip 2 - Create a 'Touch' Command to control version numbers
