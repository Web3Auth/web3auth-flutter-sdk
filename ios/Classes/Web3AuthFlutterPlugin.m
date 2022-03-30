#import "Web3AuthFlutterPlugin.h"
#if __has_include(<web3auth_flutter/web3auth_flutter-Swift.h>)
#import <web3auth_flutter/web3auth_flutter-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "web3auth_flutter-Swift.h"
#endif

@implementation Web3AuthFlutterPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftWeb3AuthFlutterPlugin registerWithRegistrar:registrar];
}
@end
