# eggnstone_amazon_chime

A wrapper for the Amazon Chime SDKs. Allows to join Chime meetings using audio and video.

## Android

🚩 **Chime does not work on Android emulators!**

https://github.com/aws/amazon-chime-sdk-android  
"NOTE: Please make sure that you are running on ARM supported devices (real devices) or simulator with arm supported. We do not support x86 currently, so simulators with x86 will not work."  

The example works on Android emulators as far as showing the version of the SDK.  
Anything else will trigger ```UnsatisfiedLinkError```.

**Instructions for your app**

* Set the min SDK version to 23 or above.
(Chime needs API level 21, but platform views cannot be displayed below API level 23.)

**Used Versions**
* [v0.17.1](https://github.com/aws/amazon-chime-sdk-android/releases/tag/v0.17.1)

**References**
* https://github.com/aws/amazon-chime-sdk-android/releases/latest
* https://aws.amazon.com/blogs/business-productivity/building-a-meeting-application-on-android-using-the-amazon-chime-sdk/

## iOS

🚩 **Chime does not work on iOS simulators!**
https://github.com/aws/amazon-chime-sdk-ios
The example works on iOS simulators as far as showing the version of the SDK.

**Instructions for your app**

* Update the project file as follows. Replace the following four files `eggnstone_amazon_chime/ios` with the ones you downloaded from [AmazonChimeSDK-0.21.3.tar.gz](https://amazon-chime-sdk-ios.s3.amazonaws.com/sdk/0.21.3/AmazonChimeSDK-0.21.3.tar.gz), [AmazonChimeSDKMedia-0.17.3.tar.gz](https://amazon-chime-sdk-ios.s3.amazonaws.com/media/0.17.3/AmazonChimeSDKMedia-0.17.3.tar.gz)
  - AmazonChimeSDK.framework
  - AmazonChimeSDK.xcframework
  - AmazonChimeSDKMedia.framework
  - AmazonChimeSDKMedia.xcframework


**Used versions**
* [AmazonChimeSDK-0.21.3.tar.gz](https://amazon-chime-sdk-ios.s3.amazonaws.com/sdk/0.21.3/AmazonChimeSDK-0.21.3.tar.gz)
* [AmazonChimeSDKMedia-0.17.3.tar.gz](https://amazon-chime-sdk-ios.s3.amazonaws.com/media/0.17.3/AmazonChimeSDKMedia-0.17.3.tar.gz)




**References**
* https://github.com/aws/amazon-chime-sdk-ios/releases/latest

## ~~Web~~

Not included yet and currently no time to do so. Sorry.

**References**
* https://aws.github.io/amazon-chime-sdk-js/
* https://github.com/aws/amazon-chime-sdk-js
