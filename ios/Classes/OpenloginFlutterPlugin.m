#import "OpenloginFlutterPlugin.h"
#if __has_include(<openlogin_flutter/openlogin_flutter-Swift.h>)
#import <openlogin_flutter/openlogin_flutter-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "openlogin_flutter-Swift.h"
#endif

@implementation OpenloginFlutterPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftOpenloginFlutterPlugin registerWithRegistrar:registrar];
}
@end
