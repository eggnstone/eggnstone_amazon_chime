#import "ChimePlugin.h"
#if __has_include(<chime/chime-Swift.h>)
#import <chime/chime-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "chime-Swift.h"
#endif

@implementation ChimePlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftChimePlugin registerWithRegistrar:registrar];
}
@end
