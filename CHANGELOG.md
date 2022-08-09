## 4.2.5

* Unified function names and data types for iOS and Android that can be retrieved from several observers.

* Added message sending/receiving function.

* Updated samples.

* Refactoring.

* Updated README.md.

* Updated CHANGELOG.md.

* iOS: Modified to build by simply replacing the following 4 files in eggnstone_amazon_chime/ios with reference to the readme.

  * AmazonChimeSDK.framework (Amazon Chime SDK framework)
  * AmazonChimeSDK.xcframework (Amazon Chime SDK framework)
  * AmazonChimeSDKMedia.framework (Amazon Chime SDK Media Framework)
  * AmazonChimeSDKMedia.xcframework (Amazon Chime SDK Media Framework)
  * Modified to build with simulator

* iOS: Added ability to get SDK version.

## 4.2.1

* Android: Allowing SDK min version of 21 for debug builds (display of video will not work but everything else should).

## 4.2.0

* Android: Updated to Chime SDK version 0.17.1.
* Android: Increased SDK min version to 23 because platform views cannot be displayed below API level 23.

## 4.1.0

* Android: Updated to Chime SDK version 0.16.0 (media 0.16.0).

## 4.0.1

* Fixed example.
* Removed unnecessary dependencies.

## 4.0.0

* Breaking change: Android: Removed SDK binaries. Getting SDK from repository now.

## 3.0.0

* Breaking change: Methods now return null on simple success (they used to return "OK").
* Breaking change: Calling audioVideoStop() does not clear the view IDs anymore. Instead use clearViewIds().

## 2.0.3

* Breaking change: Android: You need to add the .aar files to your app (see below and README.md).
* Android: Switched vom JCenter to MavenCentral.
* Android: Updated Gradle.
* Android: AAR: Switched plugin to use compileOnly() instead of implementation() to fix [#23](https://github.com/eggnstone/eggnstone_amazon_chime/issues/23).

## 2.0.1

* Android: Removed amazon-chime-sdk-combined-without-libc++_shared.so.aar.
* Android: Added amazon-chime-sdk.aar and amazon-chime-sdk-media.aar.

## 2.0.0

* Breaking change: iOS part temporarily disabled because files too large to publish.
* HELP! We need someone willing to fix the iOS part.
* Android: Updated to Chime SDK version 0.12.0 (media 0.12.1).

## 1.0.2

* Updated readme and changelog.

## 1.0.1

* Fixed plugin methods which were broken by the change to sound null safety (they return Future<String?> instead of Future<String> now).
* Android: Updated to Chime SDK version 0.11.2 (media 0.11.2).
* Added instructions on how to create amazon-chime-sdk-combined-without-libc++_shared.so.aar.

## 1.0.0

* Breaking change: Requiring Dart 2.12.0 now.

## 0.5.7

* iOS: convertVideoTileStateToJson() now includes width and height.

## 0.5.6

* iOS: Updated to Chime SDK version 0.11.1 (media 0.7.1).

## 0.5.5

* Added OnActiveSpeakerDetected and OnActiveSpeakerScoreChanged events.

## 0.5.4

* Added ListAudioDevices and ChooseAudioDevice.
* Android: Updated to Chime SDK version 0.7.4 (media 0.7.0).

## 0.5.3

* More API doc.

## 0.5.2

* More API doc.

## 0.5.1

* iOS: Reset ViewIdToViewMap on AudioVideoStart. Return flutter result on all public plugin methods.

## 0.5.0

* Added iOS part.
* Updated to Android SDK version 0.7.0 (media 0.6.0).
* Added mute/unmute.

## 0.4.2

* Adjusted example so that it can receive proper authenticated meeting data.

## 0.4.1

* Added more references to the README.md.
* Added documentation about Chime not running on Android emulators (no x86 devices supported).
* Adjusted example so that it shows a note when running on an Android emulator.

## 0.4.0

* Breaking change: Changed event and command field names.
* Breaking change: Moved libc++_shared.so out of amazon-chime-sdk-combined.aar so that apps which already have libc++_shared.so can continue to work.

## 0.3.0

* Breaking change: Changed command field names.
* Added all params to ChimeVideoTileObserver.
* Added onPlatformViewCreated to ChimeDefaultVideoRenderView.
* Fixed mapping between views and tiles.

## 0.2.0

* Breaking change: Changed event field names.
* Added params to all AudioVideoFacade events.

## 0.1.4

* Added all AudioVideoFacade events.

## 0.1.3

* Updated homepage / link to github

## 0.1.2

* Adding documentation

## 0.1.1

* Longer description and added link to Amazon Chime SDK.

## 0.1.0

* Initial release works for Android. Joining a meeting, sending and receiving audio+video works.
