#import "AwareframeworkLocationsPlugin.h"
#import <awareframework_locations/awareframework_locations-Swift.h>

@implementation AwareframeworkLocationsPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftAwareframeworkLocationsPlugin registerWithRegistrar:registrar];
}
@end
