#import "AwareframeworkLocationsPlugin.h"
#if __has_include(<awareframework_locations/awareframework_locations-Swift.h>)
#import <awareframework_locations/awareframework_locations-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "awareframework_locations-Swift.h"
#endif

@implementation AwareframeworkLocationsPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftAwareframeworkLocationsPlugin registerWithRegistrar:registrar];
}
@end
