## 0.5.7 - 06.01.2021

* iOS: convertVideoTileStateToJson() now includes width and height.

## 0.5.6 - 30.10.2020

* iOS: updated to Chime SDK version 0.11.1 (media 0.7.1).

## 0.5.5 - 29.10.2020

* Added OnActiveSpeakerDetected and OnActiveSpeakerScoreChanged events.

## 0.5.4 - 13.10.2020

* Added ListAudioDevices and ChooseAudioDevice. 
* Android: updated to Chime SDK version 0.7.4 (media 0.7.0).

## 0.5.3 - 28.08.2020

* More API doc.

## 0.5.2 - 28.08.2020

* More API doc.

## 0.5.1 - 28.08.2020

* iOS: Reset ViewIdToViewMap on AudioVideoStart. Return flutter result on all public plugin methods.

## 0.5.0 - 12.08.2020

* Added iOS part. 
* Updated to Android SDK version 0.7.0 (media 0.6.0).
* Added mute/unmute.

## 0.4.2 - 01.08.2020

* Adjusted example so that it can receive proper authenticated meeting data. 

## 0.4.1 - 01.08.2020

* Added more references to the README.md.
* Added documentation about Chime not running on Android emulators (no x86 devices supported).
* Adjusted example so that it shows a note when running on an Android emulator. 

## 0.4.0 - 26.07.2020

* Breaking change: Changed event and command field names.
* Breaking change: Moved libc++_shared.so out of amazon-chime-sdk-combined.aar so that apps which already have libc++_shared.so can continue to work.

## 0.3.0 - 25.07.2020

* Breaking change: Changed command field names.
* Added all params to ChimeVideoTileObserver. 
* Added onPlatformViewCreated to ChimeDefaultVideoRenderView. 
* Fixed mapping between views and tiles. 

## 0.2.0 - 25.07.2020

* Breaking change: Changed event field names.  
* Added params to all AudioVideoFacade events. 

## 0.1.4 - 24.07.2020

* Added all AudioVideoFacade events. 

## 0.1.3 - 24.07.2020

* Updated homepage / link to github 

## 0.1.2 - 22.07.2020

* Adding documentation 

## 0.1.1 - 22.07.2020

* Longer description and added link to Amazon Chime SDK. 

## 0.1.0 - 22.07.2020

* Initial release works for Android. Joining a meeting, sending and receiving audio+video works.
