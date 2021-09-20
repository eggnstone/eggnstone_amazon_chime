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
* Android: updated to Chime SDK version 0.12.0 (media 0.12.1). 

## 1.0.2

* Updated readme and changelog.

## 1.0.1

* Fixed plugin methods which were broken by the change to sound null safety (they return Future<String?> instead of Future<String> now).
* Android: updated to Chime SDK version 0.11.2 (media 0.11.2).
* Added instructions on how to create amazon-chime-sdk-combined-without-libc++_shared.so.aar.

## 1.0.0

* Breaking change: Requiring Dart 2.12.0 now.

## 0.5.7

* iOS: convertVideoTileStateToJson() now includes width and height.

## 0.5.6

* iOS: updated to Chime SDK version 0.11.1 (media 0.7.1).

## 0.5.5

* Added OnActiveSpeakerDetected and OnActiveSpeakerScoreChanged events.

## 0.5.4

* Added ListAudioDevices and ChooseAudioDevice. 
* Android: updated to Chime SDK version 0.7.4 (media 0.7.0).

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
