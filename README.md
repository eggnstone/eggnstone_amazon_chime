# eggnstone_amazon_chime

A wrapper for the Amazon Chime SDKs.

## Android

* Min SDK version is 21
* Add the following lines to your android/app/build.gradle in the **dependencies** section:
```
// https://frontbackend.com/maven/artifact/org.jetbrains.kotlinx/kotlinx-coroutines-android  
implementation "org.jetbrains.kotlinx:kotlinx-coroutines-android:1.3.7"  
// https://frontbackend.com/maven/artifact/org.jetbrains.kotlinx/kotlinx-coroutines-core  
implementation "org.jetbrains.kotlinx:kotlinx-coroutines-core:1.3.7"  
```
* I had to manually combine amazon-chime-sdk.aar and amazon-chime-sdk-media.aar because otherwise the contents clash. If anyone knows a better solution I'll be happy to use it!

**Used versions**
* [amazon-chime-sdk-0.5.3.tar.gz](https://amazon-chime-sdk-android.s3.amazonaws.com/sdk/0.5.3/amazon-chime-sdk-0.5.3.tar.gz)
* [amazon-chime-sdk-media-0.5.1.tar.gz](https://amazon-chime-sdk-android.s3.amazonaws.com/media/0.5.1/amazon-chime-sdk-media-0.5.1.tar.gz)

**References**
* https://aws.amazon.com/blogs/business-productivity/building-a-meeting-application-on-android-using-the-amazon-chime-sdk/

## iOS

TODO

## Web

TODO
