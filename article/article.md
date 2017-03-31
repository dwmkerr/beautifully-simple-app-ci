CI and CD for mobile apps can be challenging. Creating signed apps requires a fair amount of setup, as well as the management of secrets, certificates, keystores, provisioning profiles and so on.

In this article I'm going to demonstrate some simple tips and tricks, which will help you build and maintain beautifully simple mobile CI, regardless of the underlying technology.

## The Basic CI Pipeline

Conceptually, a CI pipeline is pretty simple:

![Basic CI Pipeline](/content/images/2017/02/1-basic-ci.png)

We take our code, perform some kind of validation (such as testing, linting, whatever), generate our artifacts and then deploy them to some devices.

Often though there's a bit more to it than that:

![Basic CI is not Basic](/content/images/2017/03/2-basic-not-basic-1.png)

Our source code has some metadata associated with it at the point in time you create your binaries, such as:

- The SHA, which uniquely identifies your exact location in the source history.
- The branch, which may have some *semantic* meaning for your project, for example `master` meaning 'production' or `alpha` meaning your current unstable public build.
- A tag, which may represent something like a semver, or may have more project-specific meaning.
- A version, which might be in something like a `package.json` or embedded in your project files for iOS or Android.

When we build we have to:

- Think about how we test and validate
- Think about how we sign
- Handle package names and bundle ids, which can cause headaches if you are going to install multiple *versions* of an app (e.g. dev and UAT builds)
- Consider build numbers and version number

So even the 'basic' CI isn't all that basic. Before we dive into some specific tricks for managing these challenges we should first establish some basic principles for mobile app CI.

## Principles

Some general principles it can be useful to follow are below. 

- Developers should be able to run all of the key CI steps on their local machine, to be able to understand, adapt and improve the process
- When building more complex features, we should create small, simple units of work which can be composed into larger pipelines
- Complexity, if needed, should be in in code - not in 'black box' CI tools

## Tip 1 - Embrace Makefiles

There are a raft of platform and framework specific tools and interfaces we will have to use in mobile projects. XCode, Gradle, NPM, framework specific CLIs, tools such as Fastlane, etc etc.

If you ensure that your main 'entrypoint' to key operations is a recipe in a makefile, you can provide a degree of consistency to mobile projects. For example:

- `make build` - Creates an IPA and APK, saving them to the `./artifacts` folder.
- `make tests` - Runs all test suites.
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

The example above example demonstrates using makefiles to handle key commands for a React Native app. In the example, CircleCI is used to handle automatic builds on code changes, and the apps themselves are distributed automatically to testers' devices with TestFairy. 

The nice feature is that the meat of the logic is in the main repo, in the `makefile` - the CI tool simply orchestrates it. Developers can run exactly the same commands on their local machine.

The [`README.md`](https://github.com/dwmkerr/beautifully-simple-app-ci/blob/master/1_react_native_app/README.md) immediately draws attention to the makefile commands:

![Screenshot of the README.md file](/content/images/2017/02/3-tip1-readme.png)

The makefiles do most of the work, that makes setting up CircleCI almost trivial. Here's a snippet of its config:

```
# Tell Circle where we keep our artifacts.
general:
  artifacts:
    - ./artifacts

# When we test, we build the android app and test it.
test:
  override:
    - make build-android
    - make test

# If there are any changes to the master branch, push a new version
# of the app.
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

iOS and Android apps have both a *version number* and a *build number*. We might have other files in our project with version numbers too (such as a `package.json` file).

It can be very useful to have a way of keeping these version numbers in sync. Again, we can use a `makefile`:

```bash
make touch
```

This command will vary in implementation depending on your platform. For example, this would be all that is needed for a Cordova based project:

```
# The version in package.json is the 'master' version.
VERSION ?= $(shell cat package.json | jq --raw-output .version)
BUILD_NUM ?= 0

touch:
    $(info "Touching to version $(VERSION) and build number $(BUILD_NUM).")
    sed -i "" -e 's/android-versionCode=\"[0-9]*\"/android-versionCode=\"$(BUILD_NUM)\"/g' ./config.xml
    sed -i "" -e 's/ios-CFBundleVersion=\"[0-9]*\"/ios-CFBundleVersion=\"$(BUILD_NUM)\"/g' ./config.xml
    sed -i "" -e 's/version=\"[.0-9a-zA-Z]*\"/version=\"$(VERSION)"/g' ./config.xml
```

Notice we don't really need complex tools for a job like this, `sed` is sufficient to quickly make changes to config files.

This works very nicely with build systems, many of which provide a build number as an environment variable. For example, we can add a build number with CircleCI like so:

```
# Turn our CircleCI specific build number environment variable into
# a plain old build number, used in the makefile.
machine:
    BUILD_NUM: $CIRCLE_BUILD_NUM

# When we test, touch the versions, run the tests, then build.
test:
    override:
      - make touch
      - make test
      - make build
```

A working example is available at:

[github.com/dwmkerr/beautifully-simple-app-ci/2_ionic_app](https://github.com/dwmkerr/beautifully-simple-app-ci/tree/master/2_ionic_app)

This sample will always set the build number in both apps and the build version to whatever is present in the `package.json` file. That means you can do awesomeness like this:

```
$ npm version minor              # Bump the version
v0.1.0
$ BUILD_NUM=3 make deploy        # Push the code
...
done
```

And all of the version numbers and build numbers are updated and the apps are deployed. In this example project, they're deployed to HockeyApp:

![Screenshot of the newly versioned apps in HockeyApp](/content/images/2017/03/6-hockey-app.png)

This build also runs on CircleCI, so only builds the Android version. You can clone the code and build the iOS version (and deploy it) using the makefile.

# Tip 3 - Label Your Icons

When you are working in a larger team, it can be very useful to label your app icon so that team members know exactly what version of the app they are using. This is often the case if you are working in a team where features or bugfixes are being deployed rapidly.

You might label your icons with build numbers, SHAs, branch names, versions, tags, or even something custom such as 'QA' or 'UAT' for different versions of your app. Here are a few examples:

TODO Screenshot of each sample app, one labeled with version
![Labelled Icons Screenshot](TODO)

I've found this to be very useful, so created a command-line tool called '[app-icon](github.com/dwmkerr/app-icon)' to help with the task. There is a `label` command to add a label, and a `generate` command to generate icons of all different sizes. This means you can add recipes like this to your `makefile`:

```
VERSION ?= $(shell cat package.json | jq --raw-output .version)
BUILD_NUM ?= 0    # This might come from Circle, Travis or Whatever...

label:
    $(info Labeling icon with '$(VERSION)' and '$(BUILD_NUM)'...)
    app-icon label -i base-icon.png -o icon.png --top $(VERSION) --bottom $(BUILD_NUM)
    app-icon generate -i icon.png
```

Each sample app labels its icon in a different way:

1. The [React Native App](./1_react_native_app/) puts the short Git SHA on the bottom of the icon.
2. The [Ionic App](./2_ionic_app/) puts the `package.json` version at the top of the icon.
3. The [Native App](./3_native_app) puts an environment label at the top of the icon, and the build number at the bottom.

# Tip 4 - Support Configurable App Ids

Another trick I've found useful is to have a command which automatically updates your iOS Bundle ID or Android Application ID. This can be handy when you have multiple versions of an app (such as a QA build, dev build, UAT build or whatever). If you have users who need to have different versions of your app on their phones, this is actually a necessary step (at least for iOS), as you cannot have multiple versions of an app with the same ID installed.

Often, I will aim to have a standard 'base id', such as:

```
com.dwmkerr.myapp
```

and then simply append whatever the 'flavour' of my app is to the end of the id:

```
com.dwmkerr.myapp_qa      # The QA build...
com.dwmkerr.myapp_uat     # The UAT build...
```

The base id is then reserved for the master build, which is what goes into production.

Just like with all of the other tricks, I tend to use a recipe in the `makefile` to do the heavy lifting, and then leave the build system to orchestrate the commands (we'll see more of this later):

```
make build                # Builds the master version of the app.
make build ENV=qa         # Builds the qa version of the app.
```


## Task List for Writeup

- [ ] Include TOC for the key topics.
- [ ] Decide on whether to use *each* tip for *each* platform. (YES)
- [ ] Add some visual pipelines for each project
- [ ] Finish the env examples, with config files


## TODO Brief Comparison of CI/CD platforms

**CircleCI**

- Very simple

**TravisCI**

- Support iOS builds out of the box for Open Source projects

Others

- Codecov
- Coveralls
- BuddyBuild
- TestFairy
- Crashlytics
