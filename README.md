# eggnstone_amazon_chime

A wrapper for the Amazon Chime SDKs. Allows to join Chime meetings using audio and video.

## Android

* **Chime does not work on Android emulators!**

https://github.com/aws/amazon-chime-sdk-android  
```"NOTE: Please make sure that you are running on ARM supported devices (real devices) or simulator with arm supported. We do not support x86 currently, so simulators with x86 will not work."```  
The example works on Android emulators as far as showing the version of the SDK.  
Anything else will trigger UnsatisfiedLinkErrors.

**Instructions for your app**

* Min SDK version is 21
* Add the following lines to your android/app/build.gradle in the **dependencies** section:
```
// https://frontbackend.com/maven/artifact/org.jetbrains.kotlinx/kotlinx-coroutines-android  
implementation "org.jetbrains.kotlinx:kotlinx-coroutines-android:1.3.7"  
// https://frontbackend.com/maven/artifact/org.jetbrains.kotlinx/kotlinx-coroutines-core  
implementation "org.jetbrains.kotlinx:kotlinx-coroutines-core:1.3.7"  
```
* If your app already uses libc++_shared.so then no further change necessary. 
* If your app does not use libc++_shared.so then
  * Copy the **folder** libc++_shared.so from example\android to your app's **android** folder
  * Add ```implementation fileTree(dir: '../libc++_shared.so', include: ['libc++_shared.so.aar'])``` to the **dependencies** section of your app's android/app/build.gradle
  
**Request for help**     
* I had to manually combine amazon-chime-sdk.aar and amazon-chime-sdk-media.aar because otherwise the contents clash. If anyone knows a better solution I'll be happy to use it!
* Then I moved the libc++_shared.so out in order to be able to use the plugin in apps that already have that library. Again, if anyone knows a better solution I'll be happy to use it!

**Used versions**
* [amazon-chime-sdk-0.7.4.tar.gz](https://amazon-chime-sdk-android.s3.amazonaws.com/sdk/0.7.4/amazon-chime-sdk-0.7.4.tar.gz)
* [amazon-chime-sdk-media-0.7.0.tar.gz](https://amazon-chime-sdk-android.s3.amazonaws.com/media/0.7.0/amazon-chime-sdk-media-0.7.0.tar.gz)

**References**
* https://github.com/aws/amazon-chime-sdk-android
* https://aws.amazon.com/blogs/business-productivity/building-a-meeting-application-on-android-using-the-amazon-chime-sdk/

## iOS

* **Chime does not work on iOS simulators!**

**Instructions for your app**

* Update your project file according to the instructions at https://github.com/aws/amazon-chime-sdk-ios#2-update-project-file.

**Used versions**
* [amazon-chime-sdk-0.11.1.tar.gz](https://amazon-chime-sdk-ios.s3.amazonaws.com/sdk-without-bitcode/0.11.1/AmazonChimeSDK-0.11.1.tar.gz)
* [amazon-chime-sdk-media-0.7.1.tar.gz](https://amazon-chime-sdk-ios.s3.amazonaws.com/media-without-bitcode/0.7.1/AmazonChimeSDKMedia-0.7.1.tar.gz)

**References**
* https://github.com/aws/amazon-chime-sdk-ios

## Web

TODO

**References**
* https://github.com/aws/amazon-chime-sdk-js
* https://aws.github.io/amazon-chime-sdk-js/
