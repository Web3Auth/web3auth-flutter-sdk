#import "OpenloginPlugin.h"
#if __has_include(<openlogin/openlogin-Swift.h>)
#import <openlogin/openlogin-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "openlogin-Swift.h"
#endif

@implementation OpenloginPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftOpenloginPlugin registerWithRegistrar:registrar];
}
@end
