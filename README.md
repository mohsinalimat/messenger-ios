# Pulse SMS - iOS

This is a Pulse client for iOS. It will simply act as a client, similar to the web, rather than the Android tablet app. Please see the [wiki page](https://github.com/klinker24/messenger-ios/wiki/FCM-and-App-Structure) about the FCM implementation and drawbacks to the iOS approach.

## Building the App

Open the `Pulse.xcworkspace` in XCode to build and edit the project. You will need a developer license to build to a real device. You can build the app to the simulator if a device isn't available. The simulator will not have FCM functionality.

### Dependency Management

I use `CocoaPods` for dependency management. The `Pods` directory is checked in to source control, so unless you are adding or changing dependencies, you shouldn't have to worry about the setup here. 

To set up `CocoaPods`:

1. Run `sudo gem install cocoapods` to install `CocoaPods`.
2. Run `pod install` to install new pods to the project.
3. Run `pod update` if you are only updating the version of existing pods.