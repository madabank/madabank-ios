fastlane documentation
----

# Installation

Make sure you have the latest version of the Xcode command line tools installed:

```sh
xcode-select --install
```

For _fastlane_ installation instructions, see [Installing _fastlane_](https://docs.fastlane.tools/#installing-fastlane)

# Available Actions

## iOS

### ios test

```sh
[bundle exec] fastlane ios test
```

Run unit tests

### ios lint

```sh
[bundle exec] fastlane ios lint
```

Run SwiftLint

### ios sync_certs

```sh
[bundle exec] fastlane ios sync_certs
```

Sync certificates and profiles (Read-only for CI)

### ios build

```sh
[bundle exec] fastlane ios build
```

Build the app for testing

### ios build_release

```sh
[bundle exec] fastlane ios build_release
```

Build for release

### ios ci

```sh
[bundle exec] fastlane ios ci
```

CI lane - runs tests and builds

### ios beta

```sh
[bundle exec] fastlane ios beta
```

Deploy to TestFlight

### ios release

```sh
[bundle exec] fastlane ios release
```

Deploy to App Store

### ios generate

```sh
[bundle exec] fastlane ios generate
```

Generate project using Tuist

### ios clean

```sh
[bundle exec] fastlane ios clean
```

Clean build artifacts

----

This README.md is auto-generated and will be re-generated every time [_fastlane_](https://fastlane.tools) is run.

More information about _fastlane_ can be found on [fastlane.tools](https://fastlane.tools).

The documentation of _fastlane_ can be found on [docs.fastlane.tools](https://docs.fastlane.tools).
