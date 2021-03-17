## How to combine amazon-chime-sdk and amazon-chime-sdk-media

* Download the latest version from
https://github.com/aws/amazon-chime-sdk-android/releases/latest
  - `amazon-chime-sdk-VERSION.tar.gz`
  - `amazon-chime-sdk-media-VERSION.tar.gz`
<!-- -->
- Extract `amazon-chime-sdk.aar`       from `amazon-chime-sdk-VERSION.tar.gz`  
- Extract `amazon-chime-sdk-media.aar` from `amazon-chime-sdk-media-VERSION.tar.gz` to `amazon-chime-sdk-media`  
<!-- -->
- Extract `amazon-chime-sdk.aar`       to `amazon-chime-sdk-combined` (notice the **-combined** here)
- Extract `amazon-chime-sdk-media.aar` to `amazon-chime-sdk-media`
<!-- -->
- Move all directories from `amazon-chime-sdk-media`   to `amazon-chime-sdk-combined`
- Add rules from `amazon-chime-sdk-media\proguard.txt` to `amazon-chime-sdk-combined\proguard.txt`
<!-- -->
- Extract `classes.jar` in `amazon-chime-sdk-combined` to `amazon-chime-sdk-combined\classes`
- Extract `classes.jar` in `amazon-chime-sdk-media`    to `amazon-chime-sdk-media\classes`
<!-- -->
- Move all contents from `amazon-chime-sdk-media\classes` to `amazon-chime-sdk-combined\classes`
- Zip contents of `amazon-chime-sdk-combined\classes` to `classes.jar` and delete `amazon-chime-sdk-combined\classes`
<!-- -->
- Delete `libc++_shared.so` from `amazon-chime-sdk-combined\jni\arm64-v8a`
- Delete `libc++_shared.so` from `amazon-chime-sdk-combined\jni\armeabi-v7a`
<!-- -->
- Zip contents of `amazon-chime-sdk-combined` to `amazon-chime-sdk-combined-without-libc++_shared.so.aar`
- Copy `amazon-chime-sdk-combined-without-libc++_shared.so.aar` to `eggnstone_amazon_chime\android\amazon-chime-sdk` 

### Note
"Zip contents" means to go into that directory and zip all files there.  
Do not zip the directory from within the directory above.
