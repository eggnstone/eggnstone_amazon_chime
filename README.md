# eggnstone_amazon_chime

A wrapper for the Amazon Chime SDKs. Allows to join Chime meetings using audio and video.

## Android

🚩 **Chime does not work on Android emulators!**

https://github.com/aws/amazon-chime-sdk-android  
"NOTE: Please make sure that you are running on ARM supported devices (real devices) or simulator with arm supported. We do not support x86 currently, so simulators with x86 will not work."  

The example works on Android emulators as far as showing the version of the SDK.  
Anything else will trigger ```UnsatisfiedLinkError```.

**Instructions for your app**

* Min SDK version is 21
* Download the files mentioned in [Used versions](#used-versions).
* Extract the contained ```.aar``` files to a new directory named ```your-app-name/android/amazon-chime-sdk```.
* Add the following lines to ```your-app-name/android/app/build.gradle``` in the **dependencies** section:
```
// https://frontbackend.com/maven/artifact/org.jetbrains.kotlinx/kotlinx-coroutines-android  
implementation "org.jetbrains.kotlinx:kotlinx-coroutines-android:1.3.7"  
// https://frontbackend.com/maven/artifact/org.jetbrains.kotlinx/kotlinx-coroutines-core  
implementation "org.jetbrains.kotlinx:kotlinx-coroutines-core:1.3.7"

implementation fileTree(dir: '../amazon-chime-sdk', include: ['amazon-chime-sdk.aar'])
implementation fileTree(dir: '../amazon-chime-sdk', include: ['amazon-chime-sdk-media.aar'])
```
* If your app already uses ```libc++_shared.so``` then you need to delete ```libc++_shared.so``` from the ```.aar``` files.

#### Used Versions
* [amazon-chime-sdk-0.12.0.tar.gz](https://amazon-chime-sdk-android.s3.amazonaws.com/sdk/0.12.0/amazon-chime-sdk-0.12.0.tar.gz)
* [amazon-chime-sdk-media-0.12.1.tar.gz](https://amazon-chime-sdk-android.s3.amazonaws.com/media/0.12.1/amazon-chime-sdk-media-0.12.1.tar.gz)

**References**
* https://github.com/aws/amazon-chime-sdk-android/releases/latest
* https://aws.amazon.com/blogs/business-productivity/building-a-meeting-application-on-android-using-the-amazon-chime-sdk/

## ~~iOS~~

**Version 2 does not support iOS**

**I need a maintainer for the iOS version!**

Version 1 has support for iOS but due to file size problems version 2 currently does not support iOS. 

🚩 **Chime does not work on iOS simulators!**

**Instructions for your app**

* Update your project file according to the instructions at https://github.com/aws/amazon-chime-sdk-ios#2-update-project-file.

**Used versions**
* [amazon-chime-sdk-0.11.1.tar.gz](https://amazon-chime-sdk-ios.s3.amazonaws.com/sdk-without-bitcode/0.11.1/AmazonChimeSDK-0.11.1.tar.gz)
* [amazon-chime-sdk-media-0.7.1.tar.gz](https://amazon-chime-sdk-ios.s3.amazonaws.com/media-without-bitcode/0.7.1/AmazonChimeSDKMedia-0.7.1.tar.gz)

**References**
* https://github.com/aws/amazon-chime-sdk-ios/releases/latest

## ~~Web~~

Not included yet and currently no time to do so. Sorry.

**References**
* https://aws.github.io/amazon-chime-sdk-js/
* https://github.com/aws/amazon-chime-sdk-js
