import Flutter
import UIKit
import SwiftyJSON
import awareframework_core
import com_awareframework_ios_sensor_core
import com_awareframework_ios_sensor_locations

public class SwiftAwareframeworkLocationsPlugin: AwareFlutterPluginCore, FlutterPlugin, AwareFlutterPluginSensorInitializationHandler, LocationsObserver {

        
    public override init() {
        super.init()
        super.initializationCallEventHandler = self
    }
    
    var locationSensor:LocationsSensor?;
    
    public static func register(with registrar: FlutterPluginRegistrar) {
        setChannels(with: registrar,
                    instance: SwiftAwareframeworkLocationsPlugin(),
                    methodChannelName: "awareframework_locations/method",
                    eventChannelName: "awareframework_locations/event")
    }
    
    public func initializeSensor(_ call: FlutterMethodCall,
                                 result: @escaping FlutterResult) -> AwareSensor? {
        if self.sensor == nil {
            if let config = call.arguments as? Dictionary<String,Any>{
                self.locationSensor = LocationsSensor.init(LocationsSensor.Config(config))
            }else{
                self.locationSensor = LocationsSensor.init(LocationsSensor.Config())
            }
            self.locationSensor?.CONFIG.sensorObserver = self
            return self.locationSensor
        }else{
            return nil
        }
    }
    
    public func onLocationChanged(data: LocationsData) {
        for handler in self.streamHandlers {
            if handler.eventName == "on_location_changed" {
                handler.eventSink(data.toDictionary())
            }
        }
    }
}
