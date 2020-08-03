#import "EggnstoneAmazonChimePlugin.h"
#if __has_include(<eggnstone_amazon_chime/eggnstone_amazon_chime-Swift.h>)
#import <eggnstone_amazon_chime/eggnstone_amazon_chime-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "eggnstone_amazon_chime-Swift.h"
#endif

@implementation EggnstoneAmazonChimePlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftEggnstoneAmazonChimePlugin registerWithRegistrar:registrar];
}
@end
